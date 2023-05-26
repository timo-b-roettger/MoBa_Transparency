%% Initial parsing
code = fileread('/Applications/Projects/2023-05-22_MoBaTransparency/parsing/PageSource_MoBaPublications_22May2023.html');
tree = htmlTree(code);
str  = extractHTMLText(tree, 'ExtractionMethod','all-text');
txt  = strsplit(str, '\n');

%% Get rid of extra content
startPoint  = find(strcmpi(txt, '2022'));
endPoint    = find(strcmpi(txt, 'Related Articles'));
toParse     = txt(startPoint:endPoint-1);
toParse     = toParse';

% Get rid of years
toRemove = num2str((2022:-1:2006)');
toParse(ismember(toParse, toRemove)) = [];

% Get rid of number of articles in some of the years
toParse(not(cellfun(@isempty, regexpi(toParse, '\d*articles')))) = [];

% Remove HTML tags
toParse = eraseTags(toParse);

% Remove "(no pagination)" and any content after that
locs = strfind(toParse, '(no pagination)');
for lines = 1:length(toParse)
    if ~isempty(locs{lines})
        toParse{lines}(locs{lines}:end) = [];
    end
end
%% Extract year
locs_allYears   = regexpi(toParse, '\(\d{4})');
allYears        = cell(length(toParse),1);
for lines       = 1:length(toParse)
    if length(locs_allYears{lines}) == 1
        allYears{lines,1} = toParse{lines}(locs_allYears{lines}+1:locs_allYears{lines}+4);
    else
        for tmp = 1:length(locs_allYears{lines})
            allYears{lines,tmp} = toParse{lines}(locs_allYears{lines}(tmp)+1:locs_allYears{lines}(tmp)+4);
        end
    end
end

% For the four entries where two years are detected, clean up
allYears = str2double(allYears);

% Any entry greater than 2023 is invalid and can be deleted
allYears(allYears > 2023) = NaN;

% Any entry which is smaller than 2006 is invalid
allYears(allYears < 2006) = NaN;

% If the second column is the same as the first column, remove second entry
allYears(allYears(:,1) == allYears(:,2),2) = NaN;

% No entries remain
if isempty(find(~isnan(allYears(:,2)), 1))
    allYears(:,2) = [];
end

%% Extract article names
% First pass - use double quotation marks
articleNames = cell(length(toParse), 1);
locQuotes    = strfind(toParse, '"');
for lines    = 1:length(toParse)
    if ~isempty(locQuotes{lines})
        articleNames{lines, :} = toParse{lines}(locQuotes{lines}(1)+1:locQuotes{lines}(2));
    end
end

% Second pass - find year and then the full stop
toSearch = setdiff(1:length(toParse), find(not(cellfun(@isempty, locQuotes))));
for loc  = 1:length(toSearch)
    currStr = toParse{toSearch(loc)};
    tmp_loc_year = regexpi(currStr, '\(\d{4})\.');
    if length(tmp_loc_year) == 1
        startPos = tmp_loc_year + 7;
        remStr   = currStr(startPos:end);
        endPos   = regexpi(remStr, '\.', 'once');
        articleNames{toSearch(loc), :} = remStr(1:endPos);
    end
end

% Handle the case of incorrectly parsed articles
toRedo = find(cellfun(@length, articleNames) < 10);
for loc = 1:length(toRedo)
    currStr = toParse{toRedo(loc)};
    tmp_loc_year = regexpi(currStr, '\(\d{4})\.');
    if length(tmp_loc_year) == 1
        startPos = tmp_loc_year + 7;
        remStr   = currStr(startPos:end);
        endPos   = regexpi(remStr, '\.');
        articleNames{toRedo(loc), :} = remStr(1:endPos(2));
    end
end

% Minor clean up - remove space from start of article name
articleNames = regexprep(articleNames, '^\o{40}', '');

% Remove quotation marks at the end of the article name
articleNames = strrep(articleNames, '"', '');

% Turn everything to lower case
articleNamesLow = lower(articleNames);


%% Results to save
results = cellstr([articleNames, num2str(allYears), toParse]);

% Write out as csv file
results = cell2table(results, 'VariableNames', {'ApproximateTitle', 'Year', 'TexttoParse'});
writetable(results, '/Applications/Projects/2023-05-22_MoBaTransparency/parsing/prasedHTML_MoBaPublications.csv', 'Delimiter', '\t');