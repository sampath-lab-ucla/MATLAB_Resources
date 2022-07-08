function BUILD(override,opts)
  % Build Builds assets, table of contents, and can package archive. See opts.

  arguments (Repeating)
    override (1,1) string
  end
  arguments
    opts.verbose (1,1) logical = false
    opts.package (1,1) logical = false
    opts.buildContents (1,1) logical= false
    opts.executeKey (1,1) logical = false
  end

  import matlab.internal.liveeditor.LiveEditorUtilities;

  root = fileparts(mfilename('fullpath'));
  [~,~] = mkdir(fullfile(root,"_pkg"));
  [~,~] = mkdir(fullfile(root,"releases"));

  % parse inputs
  if numel(override) == 1 && override{1} == "none"
    override = [];
  end
  if ~isempty(override)
    fileList = cat(2,override{:});
  else
    dirContents = dir(fullfile(root,'*.m'));
    fileList = string({dirContents.name});
    fileList(ismember(fileList,'BUILD.m')) = []; % drop build file
  end

  % make sure all files exist
  nFiles = numel(fileList);
  validFiles = false(1,nFiles);
  for f = 1:nFiles
    fileList(f) = string(LiveEditorUtilities.resolveFileName(char(fileList(f))));
    validFiles(f) = exist(fileList(f),'file');
  end

  if ~any(validFiles), error('Could not locate input files.'); end

  % clear invalid files
  if opts.verbose && any(~validFiles)
    fprintf( ...
      "Skipping invalid files: %s.\n", ...
      strjoin(strcat("'",fileList(~validFiles),"'"),", ") ...
      );
  end
  fileList(~validFiles) = [];
  % update fileList
  nFiles = sum(validFiles);

  % setup output files
  [~,outputFiles,~] = fileparts(fileList);
  outputPaths = fullfile(root,"_pkg",outputFiles); % no extension, see parser
  % send lib to _pkg directory for parse
  copyfile("lib",fullfile("_pkg","lib"));
  
  % Run the parser
  didParse = false(1,nFiles);
  for f = 1:nFiles
    if opts.verbose, fprintf("Parsing File: '%s'...",fileList(f)); end
    S = parseMToMlx( ...
      char(fileList(f)), ...
      char(outputPaths(f)), ...
      opts.executeKey ...
      );
    didParse(f) = S;
    if opts.verbose 
      if S
        fprintf(" Success!\n"); 
      else
        fprintf(" Fail!\n");
      end
    end
  end
  
  % report success
  if opts.verbose,fprintf("\nDone Parsing!\n");end

  % build the contents live script
  if opts.buildContents || ops.package
    if opts.verbose, fprintf('Building CONTENTS.mlx...');end
    makeContents(root);
    if opts.verbose, fprintf(' Done!\n');end
  end

  % determine if the build should be packaged
  if ~opts.package
    % cleanup
    if opts.verbose
      fprintf("Build Complete!\n");
    end
    return
  end
  
  if opts.verbose
    fprintf("Packaging... ");
  end
  makePackage(root);
  if opts.verbose
    fprintf("Done!\n\nBuild Complete!\n");
  end
end

%% CONTENTS
function makeContents(root)
   % idea: group name is printed as section header: case insensitive detection
  % Name (key): Title Header
  %  Description...
  % parse _pkg folder for files
  mlxFiles = getMLX(root,"_pkg");
  mlxFiles = string(mlxFiles)';
  mlxFiles(contains(mlxFiles,"CONTENTS.mlx")) = [];
  [~,mlxNames,~] = fileparts(mlxFiles);
  % drop KEY names as we will assume if a file exists so does the _key version
  isKeyName = endsWith(mlxNames,"_key");
  mlxNames(isKeyName) = [];
  % Cursory organization
  [~,sortOrder] = sort(mlxNames); % sort by type
  mlxNames = mlxNames(sortOrder);
  % Split names to determine final order
  splitNames = arrayfun(@(n)strsplit(n,"_"),mlxNames,'unif',0);
  % each split should have 3 parts
  isCmpl = cellfun(@(s)numel(s)==3,splitNames);
  splitIdOrder = cellfun(@(s)str2double(s(2)),splitNames);
  
  % names that don't comply will be put at the end in no particular order
  nonconformedIdx = isnan(splitIdOrder) | ~isCmpl;
  nonconformedNames = mlxNames(nonconformedIdx);
  
  % drop noncompliant files
  splitIdOrder(nonconformedIdx) = [];
  mlxNames(nonconformedIdx) = [];
  splitNames(nonconformedIdx) = [];
  
  % organize grouped splits
  groups = cellfun(@(s)s(1),splitNames);
  groupId = unique(groups,'stable');

  introIdx = groups == "Introduction";
  introLoc = groupId == "Introduction";

  % organize Intro First
  mlxNames = [mlxNames(introIdx);mlxNames(~introIdx)];
  splitNames = [splitNames(introIdx);splitNames(~introIdx)];
  splitIdOrder = [splitIdOrder(introIdx);splitIdOrder(~introIdx)];
  groupId = [groupId(introLoc);groupId(~introLoc)];
  groups = [groups(introIdx);groups(~introIdx)];
  
  % initialize struct holder
  cats(1:numel(groupId),1) = struct('Category',"",'Paths',"",'Files',"",'Names',"",'Titles',"",'Descriptions',"");

  % Group by internal Id
  for g = 1:numel(groupId)
    gId = groupId(g);
    gX = ismember(groups,gId);
    gF = mlxNames(gX);
    gS = splitNames(gX);
    gN = cellfun(@(s)s(3),gS); % titles
    gOrder = splitIdOrder(gX);
    [~,sOrd] = sort(gOrder);
    
    cats(g).Category = gId;
    cats(g).Paths = strcat(gF(sOrd),".m");
    cats(g).Files = gF(sOrd);
    cats(g).Names = gN(sOrd);
    % titles and descriptions to be read later.
  end
  
  % merge noncompliant names on bottom with category: Other
  if any(nonconformedIdx)
    cats(end+1) = struct( ...
      'Category',"Other", ...
      'Paths', strcat(nonconformedNames,".m"), ...
      'Names', nonconformedNames, ...
      'Files', nonconformedNames, ...
      'Titles',"", ...
      'Descriptions',"" ...
      );
  end

  nC = numel(cats);
  for c = 1:nC
    this = cats(c);
    nF = numel(this.Files);
    for f = 1:nF
      fn = this.Paths(f);
      fCnt = fileread(fn);
      fCnt = string(strsplit(fCnt,"\n"))';
      % find first %% for Title, should be first line
      titleStart = find(startsWith(fCnt,"%% "),1,'first');
      titleEnd = find(startsWith(fCnt((titleStart+1):end),"% "),1,'first') + titleStart;
      descEnd = find(startsWith(fCnt((titleEnd+1):end),"%%"),1,'first') + titleEnd;
      ttl = strtrim(regexprep(fCnt(titleStart:(titleEnd-1)), '%',''));
      ttl(ttl == "") = [];
      this.Titles(f) = strjoin(ttl," ");
      desc = strtrim(regexprep(fCnt(titleEnd:(descEnd-1)), '%',''));
      desc(desc == "") = [];
      this.Descriptions(f) = strjoin(desc," ");
    end
    cats(c) = this;
  end


  % write the contents.m file
  tmpOut = fullfile(root,"_pkg","CONTENTS.m");
  fid = fopen(tmpOut,'wt');
  fprintf(fid,"%%%% Contents\n%% \n");
  for c = 1:nC
    this = cats(c);
    fprintf(fid,"%%%%%% %s\n%% \n%% \n",this.Category);
    nF = numel(this.Files);
    for f = 1:nF
      fprintf( ...
        fid, ...
        "%% \n%s\n%% \n", ...
        tocEntry( ...
          this.Names(f), ...
          this.Titles(f), ...
          this.Files(f), ...
          this.Descriptions(f) ...
          ) ...
        );
    end
    fprintf(fid,"%% \n");
  end

  % add contents
  fclose(fid);
  pause(0.1);

  % convert to MLX
  matlab.internal.liveeditor.openAndSave(char(tmpOut),char(fullfile(root,"_pkg","CONTENTS.mlx")));
  pause(0.5);

  % remove temporary file
  delete(tmpOut);
end

%% PACKAGE
function makePackage(root)
  % package zip file
  tmpName = sprintf("MATLAB_Resources_%s",date);
  mkdir(tmpName);
  zipFile = strcat(tmpName,'.zip');
  % copy library files
  copyfile("lib",fullfile(tmpName,"lib"));
  % get packaged mlx files
  mlxFiles = getMLX(root,"_pkg");
  % copy to tmp folder
  arrayfun(@(f)copyfile(f,tmpName),mlxFiles);
  % zip folder
  zip(zipFile,tmpName);
  % cleanup
  movefile(zipFile,"releases");
  rmdir(tmpName,'s');

end

%% File Parser
function status = parseMToMlx(srcFile,dstFile,executeKey)
  arguments
    srcFile (1,:) char
    dstFile (1,:) char
    executeKey (1,1) logical = true
  end
  import matlab.internal.liveeditor.openAndSave;

  
  status = false;

  % parse file parts
  [~,srcName,srcExt] = fileparts(srcFile);

  %
  if ~strcmp(srcExt,'.m'), return; end

  try
    nargin(srcName);
  catch ME
    if ~strcmp(ME.identifier,'MATLAB:nargin:isScript')
      fprintf(2,"Error parsing '%s': '%s'\n",scrName,ME.message);
      return;
    end
  end

  % parse code file
  sourceCode = readlines(srcFile);

  % Support strings
  plainCode = convertStringsToChars(sourceCode);

  % convert to string array
  stringCode = string(plainCode);
  
  % Parse special syntax for sticky code blocks
  protectedBlocks = find(~cellfun(@isempty,regexp(stringCode,'^%!','once'),'unif',1));
  protectedBlocks = sort(protectedBlocks(:));
  protectedBlocks(:,2) = 0;
  for p = 1:size(protectedBlocks,1)
    startIdx = protectedBlocks(p,1);
    chunk = stringCode(startIdx:end);
    % find 
    aStop = ~cellfun(@isempty,regexp(chunk,'^%@','once'),'unif',1);
    cStop = ~cellfun(@isempty,regexp(chunk,'^%{2,}','once'),'unif',1);
    stopIdx = find(aStop | cStop,1,'first') + startIdx-2;
    if isempty(stopIdx)
      stopIdx = numel(stringCode);
    end
    protectedBlocks(p,2) = stopIdx;
  end
  
  %Parse special syntax for answer blocks
  answerBlocks = find(~cellfun(@isempty,regexp(stringCode,'^%@','once'),'unif',1));
  answerBlocks = sort(answerBlocks(:))+1; % make sure the ANSWER HERE gets displayed
  answerBlocks(:,2) = 0;
  for p = 1:size(answerBlocks,1)
    startIdx = answerBlocks(p,1);
    chunk = stringCode(startIdx:end);
    % find
    pStop = ~cellfun(@isempty,regexp(chunk,'^%!','once'),'unif',1);
    cStop = ~cellfun(@isempty,regexp(chunk,'^%{2,}','once'),'unif',1);
    stopIdx = find(pStop | cStop, 1, 'first') + startIdx-2;
    if isempty(stopIdx)
      stopIdx = numel(stringCode);
    end
    answerBlocks(p,2) = stopIdx;
  end

  % counts
  nProtected = size(protectedBlocks,1);
  nAnswers = size(answerBlocks,1);

  % Convert sticky blocks
  stringCode = regexprep(stringCode,'^%!', '\n% DO NOT EDIT');
  stringCode = regexprep(stringCode,'^%@', '\n% ANSWER BELOW');
  
  % write plain code to a temporary file and then use openAndSave to convert m-file
  % to mlx-file
  tmpOut = [dstFile,'_tmp.m'];

  %%% KEY  
  keyOut = [dstFile,'_key.mlx'];
  %%% WORKSHEET
  workOut = [dstFile,'.mlx'];

  % write temp file for parsing
  fid = fopen(tmpOut,'wt');
  if fid < 0, error('Error creating temporary file, check rights.'); end
  for row = 1:numel(stringCode)
    fprintf(fid,'%s\n',stringCode(row));
  end
  fclose(fid);
  pause(0.5);
  
  % parse temp file
  openAndSave(tmpOut,keyOut);
  pause(0.5);
  
  % write WORKSHEET file
  worksheetCode = stringCode;
  dropIdx = cell(nAnswers,1);
  for a = 1:nAnswers
    dropIdx{a} = answerBlocks(a,1):answerBlocks(a,2);
  end
  dropIdx = cat(2,dropIdx{:});
  
  % remove the answer blocks
  stringCode(dropIdx) = [];

  % write temp file for parsing
  fid = fopen(tmpOut,'wt');
  if fid < 0, error('Error creating temporary file, check rights.'); end
  for row = 1:numel(stringCode)
    fprintf(fid,'%s\n',stringCode(row));
  end
  fclose(fid);
  pause(0.5);
  
  % parse temp file
  openAndSave(tmpOut,workOut);
  pause(0.5);

  % Run and save the key file
  if executeKey
    matlab.internal.liveeditor.executeAndSave(keyOut);
    pause(0.05);
    evalin('base','clearvars');
  end

  % remove the tmp file and lib
  delete(tmpOut);
  
  % report success
  status = true;
end

%% Helper Functions

function mlxFiles = getMLX(root,sub)
  arguments
    root (1,1) string
  end
  arguments (Repeating)
    sub (1,1) string
  end
  pkgContents = dir(fullfile(root,sub{:},"*.mlx"));
  mlxFiles = fullfile(string({pkgContents.folder}),string({pkgContents.name}));
end

function str = tocEntry(name,title,file,desc)
  arguments 
    name (1,1) string
    title (1,1) string
    file (1,1) string
    desc (1,1) string
  end
  str = sprintf( ...
    "%% # <./%s.mlx %s> (<./%s_key.mlx key>): *%s.* %s", ...
    file, ...
    name, ...
    file, ...
    title, ...
    desc ...
    );
end
