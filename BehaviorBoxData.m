classdef BehaviorBoxData < handle
    %BehaviorBox Data class
    
    %====================================================================
    %Data Class for BehaviorBox Ver1.4
    %This Class stores all the data.
    %Trigger inputs from the hardware (decisons of animal) get entered
    %using the interface AddDecision() in the form of integers from 1-6
    %representing left correct (1), right correct (2), left wrong (3),
    %right wrong (4), time out (5) and center poke (6).
    %AddStimEvent() as interface logs the times the stimulus was presented
    
    %The input data is then logged in time and stored.
    %Get functions are used to covert that data to averages, performance
    %matrices, activity rates and others which then get plotted in the GUI.
    
    %This class is called by BehaviorBoxSuper and BehaviorBoxSub1
    
    %Meyer 2015/3
    
    %THIS FILE IS PART OF A SET OF FILES CONTAINING (ALL NEEDED):
    %BehaviorBox.fig
    %BehaviorBox.m
    %BehaviorBoxData.m
    %BehaviorBoxSub1.m
    %BehaviorBoxSub2.m
    %BehaviorBoxSuper.m
    %BehaviorBoxVisualGratingObject.m
    %BehaviorBoxVisualStimulus.m
    %BehaviorBoxVisualStimulusTraining.m
    %====================================================================
    
    
    properties
        
        %stores all data
        data_struct;
        start_time;
        
    end
    
    
    
    methods
        
        %constructor
        function this = BehaviorBoxData()
            this.data_struct = init_data_struct();
            this.start_time = clock;
            
        end
        
        
        
        
        %INPUT INTERFACE FUNCTIONS ====
        %log all activity here, which then gets passed to organize
        function AddDecision(this, what_decision, current_difficulty, stim_type, is_task_two)
            this.data_struct =  OrganizeData(this.data_struct, convertEnum(what_decision), current_difficulty, this.start_time, stim_type, is_task_two);
        end
        
        function AddResponseTime(this, response_time, response_time_bin, correct, difficulty)
            this.data_struct =  OrganizeResponseTimes(this.data_struct, response_time, response_time_bin, correct, this.start_time, difficulty);
        end
        
        
        %log stim on off events to later use to align with data
        function addStimEvent(this, event)
            this.data_struct.x_events_stim(end+1) =  etime(clock,  this.start_time)/60;
            this.data_struct.y_events_stim(end+1) =  event;
        end
        
        
        
        
        %GET DATA INTERFACE FUNCTIONS ====
        %get all activity (timeout, correct and wrong)
        function [x_all, y_activityCorrectWrong, y_Difficulty] = GetActivityCorrectWrongTimeoutDiff(this)
            [x_all, y_activityCorrectWrong, y_Difficulty] = getActivity(this.data_struct);
        end
        
        
        %get binned performance
        function [x_all, y_BinnedPerformance, y_BinnedPerformance_Error, y_Difficulty] = GetBinnedPerformance(this, Percent_bin, Performance_bin)
            [x_all, y_BinnedPerformance, y_BinnedPerformance_Error, y_Difficulty, data_struct_updated] = getBinPercentPerformance(this.data_struct, Percent_bin, Performance_bin);
            
            %update data struct
            this.data_struct = data_struct_updated;
        end
        
        
        %get further binned performance
        function [x_all, y_BinnedPerformance, y_BinnedPerformance_Error, y_Difficulty] = GetFurtherBinnedPerformance(this,Performance_bin,  Further_Performance_bin)
            [x_all, y_BinnedPerformance, y_BinnedPerformance_Error, y_Difficulty, data_struct_updated] = getFurtherBinPercentPerformance(this.data_struct, Performance_bin, Further_Performance_bin);
            
            %update data struct
            this.data_struct = data_struct_updated;
        end
        
        
        %get performance per difficulty
        function [x_all, y_PerformanceDifficulty, y_PerformanceDifficulty_Error, PerformanceDifficultyCount] = GetPerformanceDifficulty(this)
            [x_all, y_PerformanceDifficulty, y_PerformanceDifficulty_Error, PerformanceDifficultyCount] = GetPerformancePerDifficulty(this.data_struct);
        end
        
        %get performance per difficulty
        function [x_all, y_PerformanceDifficulty, y_PerformanceDifficulty_Error, PerformanceDifficultyCount] = GetPerformanceDifficultyRandom(this)
            [x_all, y_PerformanceDifficulty, y_PerformanceDifficulty_Error, PerformanceDifficultyCount] = GetPerformancePerDifficultyRandom(this.data_struct);
        end
        
        
        %get correct, wrong, difficulty with no time index only
        function [x_left, x_right, y_left, y_right, x_left2, x_right2, y_left2, y_right2 ,difficulty, x_all, y_all] = GetCorrectWrongLeftRight(this)
            [x_left, x_right, y_left, y_right, x_left2, x_right2, y_left2, y_right2 ,difficulty, x_all, y_all] = GetCorrectWrongForLeftRight(this.data_struct);
        end
        
        
        %get total responses for gui display update
        function [TotalResponses] = GetTotalResponses(this)
            [TotalResponses] = GetTotalResponsesForPlot(this.data_struct);
        end
        
        
        %get what was the previous response (correct or wrong)
        function [prevresponse] = WhatWasPrevResponse(this)
            [prevresponse] = this.data_struct.Y_data_ID_raw(end);
        end
        
        
        %get all activity (timeout, correct and wrong)
        function [x_allStim, y_StimOnOff] = GetStimOnOff(this)
            [x_allStim,y_StimOnOff] = getStimEvents(this.data_struct);
        end
        
        %get all response times correct binned 
        function [x_all_correct, y_BinnedResponses_correct, y_BinnedResponses_correct_error] = GetBinnedResponseTimesCorrect(this)
            [x_all_correct, y_BinnedResponses_correct, y_BinnedResponses_correct_error] = GetBinnedResponsesCorrect(this.data_struct);
        end
        
         %get all response times wrong binned 
        function [x_all_wrong, y_BinnedResponses_wrong, y_BinnedResponses_wrong_error] = GetBinnedResponseTimesWrong(this)
            [x_all_wrong, y_BinnedResponses_wrong, y_BinnedResponses_wrong_error] = GetBinnedResponsesWrong(this.data_struct);
        end
        
        %get response time histogram correct
        function [x_histo_Correct, y_histo_Correct] = GetResponsesHistogramCorrect(this)
            [x_histo_Correct, y_histo_Correct] = GetResponsesHistoCorrect(this.data_struct);
        end
        
        %get response time histogram wrong
        function [x_histo_Wrong, y_histo_Wrong] = GetResponsesHistogramWrong(this)
            [x_histo_Wrong, y_histo_Wrong] = GetResponsesHistoWrong(this.data_struct);
        end
       
         %get response time histogram wrong
        function [x_resp_difficulties, y_resp_difficulties] = GetResponsesDifficulties(this)
            [x_resp_difficulties, y_resp_difficulties] = GetResponsesDiff(this.data_struct);
        end
        
        
          
        %bin the previous responses (num_bins is bin size)
        function [prevMeanresponse] = WhatWasPrevMeanResponse(this, num_bins)
            if length(this.data_struct.Y_data_AllRightOrWrong) >= num_bins
                prevMeanresponse = mean( this.data_struct.Y_data_AllRightOrWrong ( (end-num_bins+1) :end) );
            else
                %nothing returned
                prevMeanresponse = -1;
            end
        end
        
        
    end %end methods
    
end %end class



%EXTERNAL FUNCTIONS ====

%convert enum to integer
function [int_out] = convertEnum(enum_decision)

switch enum_decision
    
    case 'left correct'
        int_out = 1;
    case 'right correct'
        int_out = 2;
    case 'left wrong'
        int_out = 3;
    case 'right wrong'
        int_out = 4;
    case 'time out'
        int_out = 5;
    case 'center poke'
        int_out = 6;
    otherwise
        int_out = -1;
        
end
end


%organize the response times data aspects
function [data_struct] = OrganizeResponseTimes(data_struct, response_time, response_time_bin, correct, start_time, difficulty)
%get time in minutes
current_time = etime(clock, start_time)/60;
%save the current difficulty and time
data_struct(1,1).X_data_response_times_difficulty(end+1) = current_time;
data_struct(1,1).Y_data_response_times_difficulty(end+1) = difficulty;
%if was correct choice
if correct == 1
    %add raw data
    data_struct(1,1).Y_data_response_times_raw_correct(end+1) = response_time;
    data_struct(1,1).X_data_response_times_raw_correct(end+1) = current_time;
    %if enough trials have passed to calculate average, do that
    if mod(length(data_struct(1,1).Y_data_response_times_raw_correct),response_time_bin) == 0
        %get average and errors of response times
        [data_struct(1,1).Y_data_response_times_average_correct,...
         data_struct(1,1).Y_data_response_times_average_correct_error]...
                =AverageBin(data_struct(1,1).Y_data_response_times_raw_correct, response_time_bin);
        %get average only of time as X data
        [data_struct(1,1).X_data_response_times_average_correct, ]...
                =AverageBin(data_struct(1,1).X_data_response_times_raw_correct, response_time_bin);
        %also calculate a histogram of all time distributions
        [data_struct(1,1).Y_data_response_times_hist_correct, data_struct(1,1).X_data_response_times_hist_correct]...
             = hist(data_struct(1,1).Y_data_response_times_raw_correct,10);
        %also calculate current mean difficulty
        [data_struct(1,1).Y_data_response_times_difficulty_average,]...
                =AverageBin(data_struct(1,1).Y_data_response_times_difficulty, response_time_bin);
        %also calculate current mean difficulty times
        [data_struct(1,1).X_data_response_times_difficulty_average,]...
                =AverageBin(data_struct(1,1).X_data_response_times_difficulty, response_time_bin);
        
    end
else
    data_struct(1,1).Y_data_response_times_raw_wrong(end+1) = response_time;
    data_struct(1,1).X_data_response_times_raw_wrong(end+1) = current_time;
    if mod(length(data_struct(1,1).Y_data_response_times_raw_wrong),response_time_bin) == 0
        [data_struct(1,1).Y_data_response_times_average_wrong,...
         data_struct(1,1).Y_data_response_times_average_wrong_error]...
                =AverageBin(data_struct(1,1).Y_data_response_times_raw_wrong, response_time_bin);
        [data_struct(1,1).X_data_response_times_average_wrong, ]...
                =AverageBin(data_struct(1,1).X_data_response_times_raw_wrong, response_time_bin);
       [data_struct(1,1).Y_data_response_times_hist_wrong, data_struct(1,1).X_data_response_times_hist_wrong]...
             = hist(data_struct(1,1).Y_data_response_times_raw_wrong,10);
         %also calculate current mean difficulty
        [data_struct(1,1).Y_data_response_times_difficulty_average,]...
                =AverageBin(data_struct(1,1).Y_data_response_times_difficulty, response_time_bin);
        %also calculate current mean difficulty times
        [data_struct(1,1).X_data_response_times_difficulty_average,]...
                =AverageBin(data_struct(1,1).X_data_response_times_difficulty, response_time_bin);
       
     end
end

end
 
function [average_bin, error_bin] = AverageBin(data_in, binsize)
data_size = length(data_in);
columnsToUse  = data_size - mod(data_size, binsize);
binned = reshape(data_in(1:columnsToUse), binsize,[]);
average_bin = mean(binned,1)';
error_bin = (std(binned,1)/(sqrt(size(binned,2))))';
end

%get the binned responses correct
function [x_all_correct, y_BinnedResponses_correct, y_BinnedResponses_correct_error] = GetBinnedResponsesCorrect(data_struct)
%just return them as are, they are empty if no binning has been made
x_all_correct = data_struct(1,1).X_data_response_times_average_correct;
y_BinnedResponses_correct = data_struct(1,1).Y_data_response_times_average_correct;
y_BinnedResponses_correct_error = data_struct(1,1).Y_data_response_times_average_correct_error;
end


%get the binned responses wrong
function [x_all_wrong, y_BinnedResponses_wrong, y_BinnedResponses_wrong_error] = GetBinnedResponsesWrong(data_struct)
%just return them as are, they are empty if no binning has been made
x_all_wrong = data_struct(1,1).X_data_response_times_average_wrong;
y_BinnedResponses_wrong = data_struct(1,1).Y_data_response_times_average_wrong;
y_BinnedResponses_wrong_error = data_struct(1,1).Y_data_response_times_average_wrong_error;
end

%get the response time histogram correct
function [x_histo_Correct, y_histo_Correct] = GetResponsesHistoCorrect(data_struct)
%just return them as are, they are empty if no binning has been made
x_histo_Correct = data_struct(1,1).X_data_response_times_hist_correct;
y_histo_Correct = data_struct(1,1).Y_data_response_times_hist_correct;
end 

%get the response time histogram wrong
function [x_histo_Wrong, y_histo_Wrong] = GetResponsesHistoWrong(data_struct)
%just return them as are, they are empty if no binning has been made
x_histo_Wrong = data_struct(1,1).X_data_response_times_hist_wrong;
y_histo_Wrong = data_struct(1,1).Y_data_response_times_hist_wrong;
end 


%get the response time histogram wrong
function [x_resp_difficulties, y_resp_difficulties] = GetResponsesDiff(data_struct)
%just return them as are, they are empty if no binning has been made
x_resp_difficulties = data_struct(1,1).X_data_response_times_difficulty;
y_resp_difficulties = data_struct(1,1).Y_data_response_times_difficulty;
end 


%organize the decision entered via interface into data
function [data_struct] = OrganizeData(data_struct, what_decision, current_difficulty, start_time, stim_type, is_task_two)

%organize data depending on the ID string what_decision.


%get time in minutes
current_time = etime(clock, start_time)/60;


%1. Always add to the main ID data
data_struct(1,1).X_data_ID_raw(end+1) = current_time;
data_struct(1,1).Y_data_ID_raw(end+1) = what_decision;


%2. Always add to the general acitivy (no timeout) data
data_struct(1,1).X_data_GeneralActiviy(end+1) = current_time;
data_struct(1,1).Y_data_GeneralActiviy(end+1) = 0;


%3. Always add to the difficulty log
data_struct(1,1).X_data_DifficultyLog(end+1) = current_time;
data_struct(1,1).Y_data_DifficultyLog(end+1) = current_difficulty;


%4. Always add to the stim type log (for using two trial trials)
data_struct(1,1).X_data_StimTypeLog(end+1) = current_time;
data_struct(1,1).Y_data_StimTypeLog(end+1) = stim_type;

%5. add to the right % wrong data. This then allows to just average x
%amount of data points to get the %performance of x bin
%correct, add 1
if what_decision == 1 ||  what_decision == 2
    data_struct(1,1).X_data_AllRightOrWrong(end+1) = current_time;
    data_struct(1,1).Y_data_AllRightOrWrong(end+1) = 1;
end
%wrong, add 0
if what_decision == 3 ||  what_decision == 4
    data_struct(1,1).X_data_AllRightOrWrong(end+1) = current_time;
    data_struct(1,1).Y_data_AllRightOrWrong(end+1) = 0;
end


%6. add to the right % wrong % timeout data. This is for display.
%Correct = 0.8, wrong = 0.5, timeout = 0.2;
%correct, add 4
data_struct(1,1).counter = data_struct(1,1).counter + 1;
if what_decision == 1 ||  what_decision == 2
    data_struct(1,1).X_data_AllRightOrWrongOrTimeout(end+1) = current_time;
    data_struct(1,1).Y_data_AllRightOrWrongOrTimeout(end+1) = 0.8;
    data_struct(1,1).left_right_responses(end+1) = 0.8;
    data_struct(1,1).left_right_index(end+1) = length(data_struct(1,1).left_right_index)+1;
    %1 is left correct, 2 is right correct
    %if left
    if what_decision == 2
        if is_task_two == 1
        data_struct(1,1).Y_left_only2(end+1) = 1;
        data_struct(1,1).X_left_only2(end+1) = data_struct(1,1).counter;
        else
        data_struct(1,1).Y_left_only(end+1) = 1;
        data_struct(1,1).X_left_only(end+1) = data_struct(1,1).counter; 
        end
    else
        if is_task_two == 1
        data_struct(1,1).Y_right_only2(end+1) =  1;
        data_struct(1,1).X_right_only2(end+1) = data_struct(1,1).counter;
        else
        data_struct(1,1).Y_right_only(end+1) =  1;
        data_struct(1,1).X_right_only(end+1) = data_struct(1,1).counter;
        end
    end
    
    data_struct(1,1).left_right_difficulty(end+1) = current_difficulty;
end

%wrong, add 0
if what_decision == 3 ||  what_decision == 4
    data_struct(1,1).X_data_AllRightOrWrongOrTimeout(end+1) = current_time;
    data_struct(1,1).Y_data_AllRightOrWrongOrTimeout(end+1) = 0.5;
    data_struct(1,1).left_right_responses(end+1) = 0.5;
    data_struct(1,1).left_right_index(end+1) = length(data_struct(1,1).left_right_index)+1;
    %3 is left wrong, 4 is right wrong
    %if left
    if what_decision == 3
         if is_task_two == 1
        data_struct(1,1).Y_left_only2(end+1) = 1;
        data_struct(1,1).X_left_only2(end+1) = data_struct(1,1).counter;
         else
         data_struct(1,1).Y_left_only(end+1) =  1;
        data_struct(1,1).X_left_only(end+1) = data_struct(1,1).counter;
         end
    else
        if is_task_two == 1
        data_struct(1,1).Y_right_only2(end+1) = 1;
        data_struct(1,1).X_r_only2(end+1) = data_struct(1,1).counter;
         else
        data_struct(1,1).Y_right_only(end+1) = 1;
        data_struct(1,1).X_right_only(end+1) = data_struct(1,1).counter;
        end
    end
    
    data_struct(1,1).left_right_difficulty(end+1) = current_difficulty;
    
end

%timeout
if what_decision == 5
    data_struct(1,1).X_data_AllRightOrWrongOrTimeout(end+1) = current_time;
    data_struct(1,1).Y_data_AllRightOrWrongOrTimeout(end+1) = 0.2;
end



end


%get the performance binned for the first time as requested
function [x_all, y_BinnedPerformance, y_BinnedPerformance_Error, y_Difficulty, data_struct_out] = getBinPercentPerformance(data_struct, Percent_bin, Performance_bin)

%return all empty if no binning has been made
x_all = [];
y_BinnedPerformance = [];
y_BinnedPerformance_Error = [];
y_Difficulty = [];


%calculate % if bin trials have passed for percent
if  rem(length(data_struct(1,1).X_data_AllRightOrWrong),Percent_bin) == 0
    
    if~isempty(data_struct(1,1).X_data_AllRightOrWrong)
        data_struct(1,1).X_data_PercentPerformance1stStep(end+1) =  data_struct(1,1).X_data_AllRightOrWrong(end);
        data_struct(1,1).Y_data_PercentPerformance1stStep(end+1)  = mean(data_struct(1,1).Y_data_AllRightOrWrong(end-Percent_bin+1:end));
        data_struct(1,1).Y_data_PercentPerformance1stStepDifficulty(end+1)  = mean(data_struct(1,1).Y_data_DifficultyLog(end-Percent_bin+1:end));
        
        %add this performance bin to the performance/difficulty data using
        %the difficult as index
        difficulty_index_lastbin = round( mean(data_struct(1,1).Y_data_DifficultyLog(end-Percent_bin+1:end))*10);
        
        %keep counter of entries and use as index
        tempcounter = data_struct(1,1).Y_data_AllPerformancePerDifficultyCounter(difficulty_index_lastbin+1);
        data_struct(1,1).Y_data_AllPerformancePerDifficultyCounter(difficulty_index_lastbin+1)= tempcounter+1;
        
        %use counter +1 as index for next.
        data_struct(1,1).Y_data_AllPerformancePerDifficulty(tempcounter+1,difficulty_index_lastbin+1)=  mean(data_struct(1,1).Y_data_AllRightOrWrong((end-Percent_bin)+1:end));
    end
    
    
    %calculate bins with errors if bin trials have passed for bin errors
    %from above
    if  ~isempty(data_struct(1,1).X_data_PercentPerformance1stStep)
        if  rem(length(data_struct(1,1).X_data_PercentPerformance1stStep),Performance_bin) == 0
            
            data_struct(1,1).X_data_PercentPerformanceBins2nsStep(end+1) =  data_struct(1,1).X_data_PercentPerformance1stStep(end);
            data_struct(1,1).Y_data_PercentPerformanceBins2nsStep(end+1)  = mean(data_struct(1,1).Y_data_PercentPerformance1stStep(end-Performance_bin+1:end));
            data_struct(1,1).Y_data_PercentPerformanceBins2nsStepError(end+1)  = std(data_struct(1,1).Y_data_PercentPerformance1stStep(end-Performance_bin+1:end))/sqrt(Performance_bin);
            data_struct(1,1).Y_data_PercentPerformanceBins2nsStepDifficulty(end+1)  =  mean(data_struct(1,1).Y_data_PercentPerformance1stStepDifficulty(end-Performance_bin+1:end));
            
            x_all = data_struct(1,1).X_data_PercentPerformanceBins2nsStep;
            y_BinnedPerformance = data_struct(1,1).Y_data_PercentPerformanceBins2nsStep;
            y_BinnedPerformance_Error = data_struct(1,1).Y_data_PercentPerformanceBins2nsStepError;
            y_Difficulty = data_struct(1,1).Y_data_PercentPerformanceBins2nsStepDifficulty;
            
        end
    end
end


%return data_struct to update
data_struct_out=data_struct;

end


%get the performance binned for the second time as requested
function [x_all, y_BinnedPerformance, y_BinnedPerformance_Error, y_Difficulty, data_struct_out] = getFurtherBinPercentPerformance(data_struct, Performance_bin, Further_Performance_bin)

%return all empty if no binning has been made
x_all = [];
y_BinnedPerformance = [];
y_BinnedPerformance_Error = [];
y_Difficulty = [];


%calculate bins with errors of the first bins if bin trials have passed for second bin errors
if  ~isempty(data_struct(1,1).X_data_PercentPerformanceBins2nsStep)
    %link this to previous evaulation, or it will keep evaluating until
    %the one previous increments by one
    if  rem(length(data_struct(1,1).X_data_PercentPerformance1stStep),Performance_bin) == 0
        if  rem(length(data_struct(1,1).X_data_PercentPerformanceBins2nsStep),Further_Performance_bin) == 0
            
            data_struct(1,1).X_data_PercentPerformanceBins3rdStep(end+1) =  data_struct(1,1).X_data_PercentPerformanceBins2nsStep(end);
            data_struct(1,1).Y_data_PercentPerformanceBins3rdStep(end+1)  = mean(data_struct(1,1).Y_data_PercentPerformanceBins2nsStep(end-Further_Performance_bin+1:end));
            data_struct(1,1).Y_data_PercentPerformanceBins3rdStepError(end+1)  = std(data_struct(1,1).Y_data_PercentPerformanceBins2nsStep(end-Further_Performance_bin+1:end))/sqrt(Further_Performance_bin);
            data_struct(1,1).Y_data_PercentPerformanceBins3rdStepDifficulty(end+1)  =  mean(data_struct(1,1).Y_data_PercentPerformanceBins2nsStepDifficulty(end-Further_Performance_bin+1:end));
            
            x_all = data_struct(1,1).X_data_PercentPerformanceBins3rdStep;
            y_BinnedPerformance = data_struct(1,1).Y_data_PercentPerformanceBins3rdStep;
            y_BinnedPerformance_Error = data_struct(1,1).Y_data_PercentPerformanceBins3rdStepError;
            y_Difficulty = data_struct(1,1).Y_data_PercentPerformanceBins3rdStepDifficulty;
            
        end
    end
end
%return data_struct to update
data_struct_out=data_struct;

end


%get the performance for each difficulty level
function [x_all, y_PerformanceDifficulty, y_PerformanceDifficulty_Error, PerformanceDifficultyCount] = GetPerformancePerDifficulty(data_struct)


%form average of all rows in each column and also return the
%counter
y_PerformanceDifficulty(1:11) =-1;
y_PerformanceDifficulty_Error(11) = 0;
for i = 1:11
    
    %if entries
    if data_struct(1,1).Y_data_AllPerformancePerDifficultyCounter(i)>0
        %take mean of all entries for each difficulty (use counter
        %which has the info about how many entries to take mean over
        mean_per_diff =  mean(data_struct(1,1).Y_data_AllPerformancePerDifficulty(1:data_struct(1,1).Y_data_AllPerformancePerDifficultyCounter(i),i));
        mean_per_diff_error = std(data_struct(1,1).Y_data_AllPerformancePerDifficulty(1:data_struct(1,1).Y_data_AllPerformancePerDifficultyCounter(i),i))/sqrt(data_struct(1,1).Y_data_AllPerformancePerDifficultyCounter(i));
        y_PerformanceDifficulty(i) = mean_per_diff;
        y_PerformanceDifficulty_Error(i) = mean_per_diff_error;
    end
    
end


x_all = data_struct(1,1).X_data_AllPerformancePerDifficulty;
PerformanceDifficultyCount = data_struct(1,1).Y_data_AllPerformancePerDifficultyCounter;

end

%get the correct, wrong and difficulty with even x values only
function [x_left, x_right, y_left, y_right, x_left2, x_right2, y_left2, y_right2 ,difficulty, x_all, y_all] = GetCorrectWrongForLeftRight(data_struct)
dbstop if error
%return the approriate fields
y_left = data_struct(1,1).Y_left_only;
x_left = data_struct(1,1).X_left_only;
y_right = data_struct(1,1).Y_right_only;
x_right = data_struct(1,1).X_right_only;

y_left2 = data_struct(1,1).Y_left_only2;
x_left2 = data_struct(1,1).X_left_only2;
y_right2 = data_struct(1,1).Y_right_only2;
x_right2 = data_struct(1,1).X_right_only2;

difficulty = data_struct(1,1).left_right_difficulty;
x_all =  data_struct(1,1).left_right_index;
y_all =data_struct(1,1).left_right_responses;
   
end


%get the performance for each difficulty level
function [x_all, y_PerformanceDifficulty, y_PerformanceDifficulty_Error, PerformanceDifficultyCount] = GetPerformancePerDifficultyRandom(data_struct)
dbstop if error
%go through all the data, and average all performances for each difficulty
counter0 = 0;
sum0 = 0;
data0 = [];
counter01 = 0;
sum01 = 0;
data01 = [];
counter02 = 0;
sum02 = 0;
data02 = [];
counter03 = 0;
sum03 = 0;
data03 = [];

entries =  size(data_struct(1,1).Y_data_DifficultyLog);
entries_for_percent = 4;
%go through all data
for i = 1:entries(2)
    
    %sum the correct responses (1) of each difficulty
    if data_struct(1,1).Y_data_DifficultyLog(i) == 0
        %if wrong
        if data_struct(1,1).Y_data_AllRightOrWrongOrTimeout(i) == 0.5
            counter0 = counter0 + 1;
            sum0 = sum0 + 0;
            %if correct
        elseif data_struct(1,1).Y_data_AllRightOrWrongOrTimeout(i) == 0.8
            counter0 = counter0 + 1;
            sum0 = sum0 + 1;
        end
        %if counter is passed, average in one bin and add to data
        if counter0 > entries_for_percent-1
            data0(end+1) = sum0/entries_for_percent;
            counter0 = 0;
            sum0 = 0;
        end
    elseif data_struct(1,1).Y_data_DifficultyLog(i) == 0.1
        %if wrong
        if data_struct(1,1).Y_data_AllRightOrWrongOrTimeout(i) == 0.5
            counter01 = counter01 + 1;
            sum01 = sum01 + 0;
            %if correct
        elseif data_struct(1,1).Y_data_AllRightOrWrongOrTimeout(i) == 0.8
            counter01 = counter01 + 1;
            sum01 = sum01 + 1;
        end
        %if counter is passed, average in one bin and add to data
        if counter01 > entries_for_percent-1
            data01(end+1) = sum01/entries_for_percent;
            counter01 = 0;
            sum01 = 0;
        end
    elseif data_struct(1,1).Y_data_DifficultyLog(i) == 0.2
        %if wrong
        if data_struct(1,1).Y_data_AllRightOrWrongOrTimeout(i) == 0.5
            counter02 = counter02 + 1;
            sum02 = sum02 + 0;
            %if correct
        elseif data_struct(1,1).Y_data_AllRightOrWrongOrTimeout(i) == 0.8
            counter02 = counter02 + 1;
            sum02 = sum02+ 1;
        end
        %if counter is passed, average in one bin and add to data
        if counter02 > entries_for_percent-1
            data02(end+1) =sum02/entries_for_percent;
            counter02 = 0;
            sum02 = 0;
        end
    elseif data_struct(1,1).Y_data_DifficultyLog(i) == 0.3
        %if wrong
        if data_struct(1,1).Y_data_AllRightOrWrongOrTimeout(i) == 0.5
            counter03 = counter03 + 1;
            sum03 = sum03 + 0;
            %if correct
        elseif data_struct(1,1).Y_data_AllRightOrWrongOrTimeout(i) == 0.8
            counter03 = counter03 + 1;
            sum03 = sum03 + 1;
        end
        %if counter is passed, average in one bin and add to data
        if counter03 > entries_for_percent-1
            data03(end+1) = sum03/entries_for_percent;
            counter03 = 0;
            sum03 = 0;
        end
    end
    
end


y_PerformanceDifficulty = [];
y_PerformanceDifficulty_Error = [];
PerformanceDifficultyCount(11) = 0;
x_all = [];

%just manually fill all 4 data sets
y_PerformanceDifficulty(end+1) = mean(data0);
entries =  size(data0);
y_PerformanceDifficulty_Error(end+1) = std(data0)/entries(2);
x_all(end+1) = 7;
if entries(2) > 0
    PerformanceDifficultyCount(8) = entries(2)*entries_for_percent;
else
    PerformanceDifficultyCount(8) = 0;
end

%just manually fill all 4 data sets
y_PerformanceDifficulty(end+1) = mean(data01);
entries =  size(data01);
y_PerformanceDifficulty_Error(end+1) = std(data01)/entries(2);
x_all(end+1) = 5;
if entries(2) > 0
    
    PerformanceDifficultyCount(6) = entries(2)*entries_for_percent;
else
    PerformanceDifficultyCount(6) = 0;
end


%just manually fill all 4 data sets
y_PerformanceDifficulty(end+1) = mean(data02);
entries =  size(data02);
y_PerformanceDifficulty_Error(end+1) = std(data02)/entries(2);
x_all(end+1) = 3;
if entries(2) > 0
    
    PerformanceDifficultyCount(4) = entries(2)*entries_for_percent;
else
    PerformanceDifficultyCount(4) = 0;
end


%just manually fill all 4 data sets
y_PerformanceDifficulty(end+1) = mean(data03);
entries =  size(data03);
y_PerformanceDifficulty_Error(end+1) = std(data03)/entries(2);
x_all(end+1) = 1;
if entries(2) > 0
    PerformanceDifficultyCount(2) = entries(2)*entries_for_percent;
else
    PerformanceDifficultyCount(2) = 0;
end

end


%get the total times each response occured and return as structure
function [TotalResponses] = GetTotalResponsesForPlot(data_struct)
%count 1s (left correct, 2s (right correct), 3s (left wrongs), 4s
%(right wrongs)
countthese=[1 2 3 4];
out = arrayfun(@(x)sum(data_struct(1,1).Y_data_ID_raw==x),countthese);

%all left responses
TotalResponses(1) =  out(1) + out (3);

%all right responses
TotalResponses(2) =  out(2) + out (4);

%all rewards
TotalResponses(3) =  out(1) + out (2);

% correct % total
TotalResponses(4) =  (out(1) + out (2)) / (out(1) + out (2) + out(3) + out (4)) ;

end


%get the on and off times of each stimulus presentation
function [x_allStim,y_StimOnOff] = getStimEvents(data_struct)

x_allStim = data_struct.x_events_stim;
y_StimOnOff = data_struct.y_events_stim;

end


%get each activity time point
function [x_all, y_activityCorrectWrong, y_Difficulty] = getActivity(data_struct)
x_all = data_struct(1,1).X_data_AllRightOrWrongOrTimeout;
y_activityCorrectWrong = data_struct(1,1).Y_data_AllRightOrWrongOrTimeout;
y_Difficulty = data_struct(1,1).Y_data_DifficultyLog;
end


%initialize data structure
function [struct_out] = init_data_struct()

struct_out = struct('X_vector_activity',[]);
struct_out(1,1).Y_data_activity = [];
struct_out(1,1).X_data_ID_raw = [];
struct_out(1,1).Y_data_ID_raw = [];
struct_out(1,1).X_data_GeneralActiviy = [];
struct_out(1,1).Y_data_GeneralActiviy  = [];
struct_out(1,1).X_data_DifficultyLog  = [];
struct_out(1,1).Y_data_DifficultyLog  = [];
struct_out(1,1).X_data_StimTypeLog = [];
struct_out(1,1).Y_data_StimTypeLog = [];
struct_out(1,1).X_data_AllRightOrWrong  = [];
struct_out(1,1).Y_data_AllRightOrWrong  = [];
struct_out(1,1).X_data_AllRightOrWrong  = [];
struct_out(1,1).Y_data_AllRightOrWrong  = [];
struct_out(1,1).X_data_AllRightOrWrongOrTimeout  = [];
struct_out(1,1).Y_data_AllRightOrWrongOrTimeout = [];
struct_out(1,1).X_data_AllRightOrWrongOrTimeout  = [];
struct_out(1,1).Y_data_AllRightOrWrongOrTimeout  = [];
struct_out(1,1).X_data_AllRightOrWrongOrTimeout = [];
struct_out(1,1).Y_data_AllRightOrWrongOrTimeout  = [];
struct_out(1,1).X_data_PercentPerformance1stStep = [];
struct_out(1,1).Y_data_PercentPerformance1stStep  = [];
struct_out(1,1).Y_data_PercentPerformance1stStepDifficulty  = [];
struct_out(1,1).X_data_PercentPerformanceBins2nsStep = [];
struct_out(1,1).Y_data_PercentPerformanceBins2nsStep  = [];
struct_out(1,1).Y_data_PercentPerformanceBins2nsStepError  = [];
struct_out(1,1).Y_data_PercentPerformanceBins2nsStepDifficulty  = [];
struct_out(1,1).X_data_PercentPerformanceBins3rdStep =  [];
struct_out(1,1).Y_data_PercentPerformanceBins3rdStep  = [];
struct_out(1,1).Y_data_PercentPerformanceBins3rdStepError  = [];
struct_out(1,1).Y_data_PercentPerformanceBins3rdStepDifficulty  =  [];
struct_out(1,1).X_data_AllPerformancePerDifficulty =[0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0];
struct_out(1,1).Y_data_AllPerformancePerDifficulty = [];
struct_out(1,1).Y_data_AllPerformancePerDifficultyCounter = zeros(1,11);
struct_out(1,1).x_events_stim =  [];
struct_out(1,1).y_events_stim =  [];
struct_out(1,1).Y_left_only=  [];
struct_out(1,1).X_left_only=  [];
struct_out(1,1).Y_right_only=  [];
struct_out(1,1).X_right_only=  [];
struct_out(1,1).Y_left_only2=  [];
struct_out(1,1).X_left_only2=  [];
struct_out(1,1).Y_right_only2=  [];
struct_out(1,1).X_right_only2=  [];

struct_out(1,1).left_right_difficulty=  [];
struct_out(1,1).left_right_responses=  [];
struct_out(1,1).left_right_index=  [];
struct_out(1,1).counter = 0;
struct_out(1,1).Y_data_response_times_raw_correct =  [];
struct_out(1,1).X_data_response_times_raw_correct =  [];
struct_out(1,1).Y_data_response_times_average_correct =  [];
struct_out(1,1).Y_data_response_times_average_correct_error =  [];
struct_out(1,1).X_data_response_times_average_correct =  [];
struct_out(1,1).Y_data_response_times_hist_correct =  [];
struct_out(1,1).X_data_response_times_hist_correct =  [];
struct_out(1,1).Y_data_response_times_raw_wrong =  [];
struct_out(1,1).X_data_response_times_raw_wrong =  [];
struct_out(1,1).Y_data_response_times_average_wrong =  [];
struct_out(1,1).Y_data_response_times_average_wrong_error =  [];
struct_out(1,1).X_data_response_times_average_wrong =  [];
struct_out(1,1).Y_data_response_times_hist_wrong =  [];
struct_out(1,1).X_data_response_times_hist_wrong =  [];
struct_out(1,1).X_data_response_times_difficulty =  [];
struct_out(1,1).Y_data_response_times_difficulty =  [];

 
end
