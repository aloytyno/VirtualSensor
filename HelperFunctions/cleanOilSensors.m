function FlightData = cleanOilSensors(FlightData)
	
    if class(FlightData) == "timetable"
        FlightData = timetable2table(FlightData);
    end
    % Fill outliers
	FlightData = filloutliers(FlightData,"linear","movmedian",100,...
	    "DataVariables",["OilPressure","OilTemperature"]);
end