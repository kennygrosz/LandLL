function writeCsvFile(filename, array, header_str)

    if (nargin < 3)
        header_str = [];
    end

    out_fid = fopen(filename, 'w');
    
    if (~out_fid)
        fprintf(1, 'Could not open %s for writing\n', filename);
        return;
    end
   
    array_dim = size(array);
    
    % build up the printf format string
    format_str = '';
    for i = 1:array_dim(2) % Num columns
        format_str = [format_str '%.5f,'];
    end

    % remove last comma and add newline
    format_str = [format_str(1:end-1) '\n'];
    
    % write header string
    if (~isempty(header_str))
        fprintf(out_fid, '%s\n', header_str);
    end
    
    % write values
    fprintf(out_fid, format_str, array);
  
    
    fclose(out_fid);
    
end