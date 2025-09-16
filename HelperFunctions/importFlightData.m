function FlightData = importFlightData(workbookFile, sheetName, dataLines)
    % importFlightData imports flight data from an Excel file.
    % 
    % Inputs:
    %   workbookFile - The path to the Excel file.
    %   sheetName - The name or index of the sheet to read from (optional).
    %   dataLines - The range of rows to read (optional).
    %
    % Outputs:
    %   FlightData - A table containing the imported flight data.
    %
    % Example usage:
    %   FlightData = importFlightData('flight_data.xlsx', 'Sheet1', [2, 100]);

    % Set default sheet name if not provided
    if nargin == 1 || isempty(sheetName)
        sheetName = 1; % Default to the first sheet
    end

    % Set default data range if not provided
    if nargin <= 2
        dataLines = [2, 47313]; % Default to rows 2 to 47313
    end

    % Create import options for reading the spreadsheet
    opts = spreadsheetImportOptions("NumVariables", 13);
    opts.Sheet = sheetName; % Specify the sheet to read from
    opts.DataRange = "A" + dataLines(1, 1) + ":M" + dataLines(1, 2); % Set the data range
    opts.VariableNames = ["Time", "FuelQuantity", "OilPressure", "OilTemperature", ...
                          "LatitudePosition", "LongitudePosition", "Altitude", ...
                          "ExhaustTemperature", "FuelFlow", "FanSpeed", ...
                          "TrueAirSpeed", "WindDirection", "WindSpeed"]; % Define variable names
    opts.VariableTypes = ["datetime", "double", "double", "double", "double", ...
                          "double", "double", "double", "double", "double", ...
                          "double", "double", "double"]; % Define variable types

    % Set the input format for the 'Time' variable
    opts = setvaropts(opts, "Time", "InputFormat", "");

    % Read the data from the specified range and store it in FlightData
    FlightData = readtable(workbookFile, opts, "UseExcel", false);

    % Loop through additional data lines if specified
    for idx = 2:size(dataLines, 1)
        opts.DataRange = "A" + dataLines(idx, 1) + ":M" + dataLines(idx, 2); % Update data range
        tb = readtable(workbookFile, opts, "UseExcel", false); % Read additional data
        FlightData = [FlightData; tb]; % Append the new data to FlightData
    end
end