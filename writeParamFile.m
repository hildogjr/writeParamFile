% Write a parameter file compatible with C/C++ and Python language. The
% file is populated with the values the mentioned variables of the base
% workspace. My personal use of this function is export configuration to
% DSP C/C++ softwares and PSIM simulations (.txt extesion).
%  writeParamFile fileName 'Description group one' var1 var2 var3 ...
%   'Description group two' ...
%  writeParamFile fileName 'Description group three' matrix1 ...
%  writeParamFile % At the end to close the opened file.
%
% The open file command should be used just one, a sequential script e.g.:
% writeParamFile fileName
% writeParamFile var1 '\\ Description of this variable.'
% writeParamFile 'Description group one' var1 var2 var3
%
% The decriptions are add as a general header group. To add a comment by
% line usethe bellow examples. The first input (file name) may or may not
% be used.
% writeParamFile '\\ Description.'
% writeParamFile var1 '\\ Description of this variable.'
% ...
%
%  Written by Hildo Guillardi Júnior
%  Written in Matlab R2017a (needs > R2016 to run) on 6/Apr/2020.
%  On 08/Apr/2020 add the variable type definitions to C/C++ and in line
% description.

function writeParamFile(varargin)
    persistent fileID fileType
    
    if ~isempty(fileID) && fileID<0, fileID=[]; end
    
    %if strcmp(varargin{1}, 'close') || isempty(varargin)
    if isempty(varargin)
        if ~isempty(fileID)
            fclose(fileID);
            fileID = [];
        else
            disp('All files already closed.')
        end
        return
    end

    if isempty(fileID)
        fileName = varargin{1};
        fileID = fopen(fileName, 'w');
        [~, ~, fileType] = fileparts(fileName);
        fileType = lower(fileType);
        varargin{1} = []; % The first input argument is already used. Iterate the last command on next input arguments.
    end

    if isempty(fileID) || fileID<0 % In this point the file must be opened.
        error('No file opened.')
    end
    
    
    
    % Termination needed in some languages
    switch fileType
        case {'.h', '.c', '.cpp', '.hpp'}
            termination = ';';
        case '.py'
            termination = '';
        otherwise
            termination = '';
    end
    % Vector and list identifiers in some languages
    switch fileType
        case {'.h', '.c', '.cpp', '.hpp'}
            start_vector = '{';
            end_vector = '}';
        case '.py'
            start_vector = '[';
            end_vector = ']';
        otherwise
            start_vector = '{';
            end_vector = '}';
    end
    
    % Iterate in all varaibles and comments to save line-by-line.
    for countVar = 1:length(varargin)
        varName = varargin{countVar};
        if ~isempty(varName)
            try
                value = evalin('base', varName);
                if iscell(value)
                    erro('C language or PSIM doesn''t recognize Matlab''s cells. It is not saved in any language file until now.')
                end
                
                % Variable type identifiers in some languages
                switch fileType
                    case {'.h', '.c', '.cpp', '.hpp'}
                        if islogical(value)
                            var_identifier = 'const bool ';
                        elseif mod(value, 1)==0
                            var_identifier = 'int ';
                            if all(value>=0)
                                var_identifier = ['unsigned ', var_identifier];
                            end
                            var_identifier = ['const ', var_identifier];
                        else
                            var_identifier = 'const float ';
                        end
                    case '.py'
                        var_identifier = '';
                    otherwise
                        var_identifier = '';
                end
                fprintf(fileID, '%s%s = ', var_identifier, varName);
                
                % Unique value or vector logic to write.
                if all(size(value)==[1,1])
                    writeCurrentParameter(value)
                else
                    
                    fprintf(fileID, start_vector);
                    [num_row, num_col] = size(value);
                    for count_row = 1:num_row
                        if count_row>1
                            fprintf(fileID, '\t');
                        end
                        for count_col = 1:num_col
                            writeCurrentParameter(value)
                            if count_row<=num_row && count_col<num_col
                                fprintf(fileID, ', ');
                            end
                        end
                        if count_row>1 && count_row>num_row
                            fprintf(fileID, '\n');
                        end
                    end
                    fprintf(fileID, end_vector);
                end
                
                fprintf(fileID, termination);
                fprintf(fileID, '\n');
            catch
                eval(sprintf('fprintf(fileID, ''%s\\n'');', varName)) % To be possible interpret `'\n'`.
            end
        end
    end

    function writeCurrentParameter(value)
        if islogical(value)
            switch fileType
                case {'.h', '.c', '.cpp', '.hpp'}
                    if value, value='true'; else, value='false'; end
                case '.py'
                    if value, value='True'; else, value='False'; end
                otherwise
                    if value, value='1'; else, value='0'; end
            end
            fprintf(fileID, value);
        elseif mod(value, 1)==0
            fprintf(fileID, '%i', value);
        else
            fprintf(fileID, '%g', value);
        end
    end
    
end
