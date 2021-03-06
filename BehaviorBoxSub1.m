classdef BehaviorBoxSub1 < BehaviorBoxSuper
    %BehaviorBox Sub class 1 (Contour Task)
    
    %====================================================================
    %Sub Class 1 for BehaviorBox Ver1.4
    %This Class is called by the GUI BehaviorBox via RunTrials() and runs
    %the main Trial loop, reads levers, gives rewards,
    %plots data, adjust difficulty depending on performance, etc.
    %It stores data in the BehaviorBoxData.m file/object which is uses to
    %calculate averages, performances, etc.
    
    %It interacts with class BehaviorBoxVisualStimulus.m to create the
    %visual stimuli.
    
    %This class inherits from BehaviorBoxSuper from which it overrides some functions with added functionality.
    
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
    
    
    properties (SetAccess = protected)
        
        %         CREATED BY SUPEROBJECT:
        %         Variable_Struct;
        %         Data_Object;
        %         Setting_Struct;
        
        counter_for_alternate;
        counter_for_alternate_2_tasks;
        current_side;
        
    end
    
    
    methods
        
        function this = BehaviorBoxSub1(GUI_handles)
            %if psychometric, set GUI setting before running parent
            %constructor to take those changes
            temp_adjust_method = get(GUI_handles.popupmenu9,'Value');
            if get(GUI_handles.popupmenu1,'Value') ==9
                set(GUI_handles.edit42,'String',num2str(0));
                set(GUI_handles.edit40,'String',num2str(0.3));
                set(GUI_handles.popupmenu9,'Value',3);
                
            end
            
            %call the constructor of the super group to initiale supergroup
            
            this = this@BehaviorBoxSuper(GUI_handles);
            %add local
            this.counter_for_alternate = 0;
            this.counter_for_alternate_2_tasks = 0;
            this.current_side = 'left';
            set(GUI_handles.popupmenu9,'Value',temp_adjust_method);
        end
        
        % INTERFACE====
        function  RunTrials(this)
            %overwrite DoLoop from super class
            this.DoLoop();
        end
        
        
        %MEMBER FUNCTIONS====
        
        %overrides super function DoLoop
        function DoLoop(this) %=====MAIN LOOP===========================
            disp('- - - - -');
            dbstop if error
            
            %LOCAL VARIABLES
            
            
            %GUI handles
            stop_handle = this.Setting_Struct(1,1).GuiHandles.pushbutton2;
            message_handle = this.Setting_Struct(1,1).GuiHandles.text1;
            GUI_handle = gcf; %current GUI handle for save
            
            timeout_counter = 0;
            performanceAdjust_counter_raise = 0;
            performanceAdjust_counter_lower = 0;
            real_time = clock;
            
            
            %current stimulus side (left is 1, right is 11)
            StimLeftOrRight = 1;
            isLeftTrial = 0;
            current_task = 1;
            %performance thresholds as to when to adjust the difficulty
            upperperformance = this.Setting_Struct(1,1).RaiseThres;
            lowerperformance = this.Setting_Struct(1,1).LowerThres;
            
            %set opacity
            current_opacity = this.Setting_Struct(1,1).Starting_opacity;
            max_contrast = 1;
            
            %create sound objects
            if this.Setting_Struct(1,1).Play_sound
                Sound_start_Object = audioplayer(this.Variable_Struct(1,1).soundstart, 48000);
                Sound_correct_Object = audioplayer(this.Variable_Struct(1,1).soundcorrect, 48000);
                Sound_cue_Object = audioplayer(this.Variable_Struct(1,1).soundcue, 48000);
            else
                %make dummy paramenter
                Sound_start_Object = 1;
                Sound_correct_Object = 1;
                Sound_cue_Object = 1;
            end
            
            
            
            %initialize GUI numbers and buttons
            this.SetupBeforeLoop();
            Current_Stim_Object = [];
            
            
            
            
            %START LOOP
            %wait for trigger to start experiment if set in GUI
            if this.Setting_Struct(1,1).Ext_trigger
                
                set(this.Setting_Struct(1,1).GuiHandles.text1,'String','Waiting for trigger to start..', 'BackgroundColor','blue');
                
                while ~ this.Variable_Struct.a.digitalRead(this.Setting_Struct(1,1).TriggerPin)
                    %check if abort button is pressed
                    if this.checkAbort(stop_handle,this.Setting_Struct(1,1).GuiHandles.text1)==1;
                        %abort
                        break;
                    end
                    pause(0.01);
                end
                
                set(this.Setting_Struct(1,1).GuiHandles.text1, 'BackgroundColor',[0.94 0.94 0.94]);
            end
            
            
            
            %RUN loop
            for i = 1:this.Setting_Struct(1,1).Max_trial_num
                
                %check if stop pressed
                if this.checkAbort(stop_handle,message_handle)==1
                    %abort
                    break;
                end
                
                %if using ball, reset counter on connected arduino (set high)
                if this.Setting_Struct(1,1).use_ball == 1
                    this.SetLED(this.Variable_Struct(1,1).a, this.Setting_Struct(1,1).ResetPin, 1);
                end
                
                %update GUI
                this.updateGUIbeforeIteration(i, timeout_counter, current_opacity, real_time);
                
                %adjust Difficulty if necessary
                [performanceAdjust_counter_raise,performanceAdjust_counter_lower, current_opacity] = this.adjustDifficulty(performanceAdjust_counter_raise, performanceAdjust_counter_lower, current_opacity, upperperformance, lowerperformance);
                
                %pick side
                [StimLeftOrRight,isLeftTrial] = this.PickSideForCorrect(StimLeftOrRight,isLeftTrial, i);
                
                %if using ball, reset counter on connected arduino (set low)
                if this.Setting_Struct(1,1).use_ball == 1
                    this.SetLED(this.Variable_Struct(1,1).a, this.Setting_Struct(1,1).ResetPin, 0);
                end
                
                %if two tasks, set which task is current
                
                if  this.Setting_Struct(1,1).Stimulus_type == 8
                    
                    current_task = this.set_current_task(current_task);
                    %set current task stimulus
                    if current_task == 1
                        %task 1
                        stim_type = 6;
                    else
                        %task 2
                        stim_type = 7;
                    end
                    
                    % if only single task
                else
                    stim_type = this.Setting_Struct(1,1).Stimulus_type;
                end
                
                %wait for input to initialize trial if set
                if this.Setting_Struct(1,1).Initialize_by_input ==1
                    this.WaitForInput(this);
                    
                end
                
                %show cue if two task stimulus
                if this.Setting_Struct(1,1).IsCueTrial == 1
                    play(Sound_cue_Object);
                    this.ShowCue(current_task, stim_type);
                    stop(Sound_cue_Object);
                end
                
                
                %present stimulus
                [Current_Stim_Object] = this.PresentAllStimulusAspects( current_opacity, StimLeftOrRight, current_task, stim_type);
                
                
                %if using ball, reset counter on connected arduino (set high)
                if this.Setting_Struct(1,1).use_ball == 1
                    this.SetLED(this.Variable_Struct(1,1).a, this.Setting_Struct(1,1).ResetPin, 1);
                end
                
                
                %turn on LED
                this.SetLED(this.Variable_Struct(1,1).a, this.Setting_Struct(1,1).LED, 1);
                %let Matlab catch up
                pause(0.01);
                
                
                %ignore input if set
                if  this.Setting_Struct(1,1).Input_ignored ==1
                    set(this.Setting_Struct(1,1).GuiHandles.text1,'String',['Ignoring Input for ',num2str(this.Setting_Struct(1,1).Pokes_igonerd_time),' seconds..']);
                    
                    pause(this.Setting_Struct(1,1).Pokes_igonerd_time);
                    
                end
                
                
                
                %if using ball, reset counter on connected arduino (set low)
                if this.Setting_Struct(1,1).use_ball == 1
                    this.SetLED(this.Variable_Struct(1,1).a, this.Setting_Struct(1,1).ResetPin, 0);
                end
                
                
                %wait for response or timeout (static, pass this and call
                %this)
                
                [what_decision,response_time] = this.WaitForInputAndGiveReward(this, Current_Stim_Object, isLeftTrial, Sound_start_Object, Sound_correct_Object);
                
                %if response was a timeout
                if  strcmp(what_decision , 'time out') == 1
                    timeout_counter = timeout_counter+1;
                end
                
                % check if current trial is 2 task and if it is the second
                % task
                if current_task == 1
                    is_task_two = 0;
                else
                    is_task_two = 1;
                end
                
                
                
                %add decision event and stimulus type to data object
                this.Data_Object.AddDecision(what_decision, current_opacity, this.Setting_Struct(1,1).Stimulus_type, is_task_two);
                
                %add response time to data object only if correct or wrong
                %(no timeout)
                if  strcmp(what_decision , 'left wrong') == 1 || strcmp(what_decision , 'right wrong') == 1
                    this.Data_Object.AddResponseTime(response_time, this.Setting_Struct(1,1).RespTimeBin, 0, current_opacity);
                elseif  strcmp(what_decision , 'left correct') == 1 || strcmp(what_decision , 'right correct') == 1
                    this.Data_Object.AddResponseTime(response_time, this.Setting_Struct(1,1).RespTimeBin, 1, current_opacity);
                end
                
                %check if stop pressed, and do not plot data if aborted
                if this.checkAbort(stop_handle,message_handle)==1;
                    %abort
                    break;
                else
                    %plot activity
                    this.plotData();
                end
                
                
                %wait for penalty if wrong and add intertrial time
                if  strcmp(what_decision , 'left wrong') == 1 || strcmp(what_decision , 'right wrong') == 1
                    set(this.Setting_Struct(1,1).GuiHandles.text1,'String',[what_decision,'- Penalty delay for ',num2str(this.Setting_Struct(1,1).Penalty_time),' seconds..']);
                    pause(this.Setting_Struct(1,1).Intertrial_time +  this.Setting_Struct(1,1).Penalty_time);
                else
                    %wait for intertrial time only
                    pause(this.Setting_Struct(1,1).Intertrial_time);
                end
                
                
            end %END OF LOOP
            
            
            
            %save
            this.SaveAllData(this, GUI_handle);
            %clean up
            this.cleanUp(Current_Stim_Object, Sound_start_Object);
            
            
        end  %=====END OF MAIN LOOP===========================
        
        
        
        function SetupBeforeLoop(this)
            
            %update gui
            this.setGuiNumbers(this.Setting_Struct(1,1).GuiHandles, this.Setting_Struct(1,1).GUI_numbers);
            this.clearAxes(this.Setting_Struct(1,1).GuiHandles);
            
            %create stimulus depending on input device (inherited from super)
            this.makeListOfStims();
            
            %print start time
            disp_string = ['Start trial Mouse ',this.Setting_Struct(1,1).Animal_ID, ' at ',datestr(now)];
            disp(disp_string);
            
            %see if cue trial
            if this.Setting_Struct(1,1).Stimulus_type == 6 || this.Setting_Struct(1,1).Stimulus_type == 7 || this.Setting_Struct(1,1).Stimulus_type == 8
                this.Setting_Struct(1,1).IsCueTrial = 1;
            else
                this.Setting_Struct(1,1).IsCueTrial = 0;
            end
            
            %update legend if two task
            if  this.Setting_Struct(1,1).Stimulus_type == 8
                set(this.Setting_Struct(1,1).GuiHandles.text33,'String','Task 1 (white)');
                set(this.Setting_Struct(1,1).GuiHandles.text32,'String','Task 2 (magenta)');
                
            else
                set(this.Setting_Struct(1,1).GuiHandles.text33,'String','left side (cyan)');
                set(this.Setting_Struct(1,1).GuiHandles.text32,'String','right side (yellow)');
                
            end
        end
        
        
        
        function updateGUIbeforeIteration(this, i, timeout_counter, current_opacity, real_time)
            
            %add local variables to Gui Numbers
            this.Setting_Struct.GUI_numbers.trial_no = i;
            this.Setting_Struct.GUI_numbers.choices = i- timeout_counter;
            this.Setting_Struct.GUI_numbers.difficulty = current_opacity;
            this.Setting_Struct.GUI_numbers.time = etime(clock, real_time)/60;
            
            %update Gui window
            this.setGuiNumbers(this.Setting_Struct(1,1).GuiHandles, this.Setting_Struct(1,1).GUI_numbers);
        end
        
        
        
        function [performanceAdjust_counter_raise,performanceAdjust_counter_lower, current_opacity] = adjustDifficulty(this, performanceAdjust_counter_raise, performanceAdjust_counter_lower, current_opacity, upperperformance, lowerperformance)
            
            %adjust opacity on performance if needed
            if this.Setting_Struct(1,1).DiffAdjustMethod==1
                %if need to raise difficulty is true
                if this.Setting_Struct(1,1).Raise_bg_with_perf ==1
                    
                    %if counter reaches threshold
                    if  performanceAdjust_counter_raise > this.Setting_Struct(1,1).RaiseDiffAfterBins-1
                        
                        
                        %if the mean of the performance is higher than
                        %threshold, adjust
                        if this.Data_Object.WhatWasPrevMeanResponse(this.Setting_Struct.RaiseDiffAfterBins) > upperperformance
                            
                            current_opacity = current_opacity+0.1;
                            if current_opacity >1
                                current_opacity = 1;
                            end
                            %reset counter to 0, so you wait at least the number of
                            %bins you average over before you do the next check
                            performanceAdjust_counter_raise = 0;
                        end
                    end
                    %inc counter
                    performanceAdjust_counter_raise = performanceAdjust_counter_raise +1;
                    
                end
                
                
                %if need to lower difficulty
                if this.Setting_Struct(1,1).Raise_bg_with_perf ==1
                    
                    
                    if  performanceAdjust_counter_lower > this.Setting_Struct(1,1).LowerDiffAfterBins-1
                        
                        
                        if  this.Data_Object.WhatWasPrevMeanResponse(this.Setting_Struct.LowerDiffAfterBins) < lowerperformance &&  this.Data_Object.WhatWasPrevMeanResponse(this.Setting_Struct.LowerDiffAfterBins) ~=-1
                            current_opacity = current_opacity-0.1;
                            if current_opacity <0
                                current_opacity = 0;
                            end
                            performanceAdjust_counter_lower = 0;
                        end
                    end
                    %increase counter by one
                    performanceAdjust_counter_lower = performanceAdjust_counter_lower+1;
                    
                end
                %if below minimum set, use minimum set
                if current_opacity < this.Setting_Struct(1,1).Starting_opacity
                    current_opacity = this.Setting_Struct(1,1).Starting_opacity;
                end
                
                
            end
            
            
            
            %step up difficulty if needed
            if this.Setting_Struct(1,1).DiffAdjustMethod==2
                %if the number of trials per step has been reached,
                %increase difficulty
                if mod(this.Setting_Struct.GUI_numbers.choices, this.Setting_Struct(1,1).StepUpAfter) == 0
                    current_opacity = current_opacity+0.1;
                    %if larger than 1, start over
                    if current_opacity >1
                        current_opacity = this.Setting_Struct(1,1).Starting_opacity;
                    end
                    
                end
                
            end
            
            if this.Setting_Struct(1,1).DiffAdjustMethod==3
                
                %randomize difficulty if needed
                %pick random number between the upper and lower range
                %get range of all difficulties as integer
                
                num_increments =  floor(((this.Setting_Struct(1,1).RandomMax*10) -  (this.Setting_Struct(1,1).RandomMin*11))/(this.Setting_Struct(1,1).RandomStep*10))+2;
                
                %now get a random number within the range
                % rand_opacity  = floor(rand()*5*10)/10;
                rand_opacity  = floor(rand()*num_increments*10/10);
                %add that to min
                current_opacity = ((round(rand_opacity*(this.Setting_Struct(1,1).RandomStep*10)))/10) +this.Setting_Struct(1,1).RandomMin;
                
                if current_opacity >this.Setting_Struct(1,1).RandomMax
                    current_opacity = this.Setting_Struct(1,1).RandomMax;
                end
                
                
            end
            
        end
        function [Current_Stim_Object] = PresentAllStimulusAspects(this, current_opacity, StimLeftOrRight,current_task, stim_type)
            %if two task
            if this.Setting_Struct(1,1).Stimulus_type == 8
                %use first task
                if  current_task == 1
                    Current_Stim_Object = this.Variable_Struct(1,1).List_of_stims(int8((current_opacity*10)+StimLeftOrRight));
                    
                else
                    
                    Current_Stim_Object = this.Variable_Struct(1,1).List_of_stims2(int8((current_opacity*10)+StimLeftOrRight));
                    
                end
                
            else
                
                %get current stim object (use int, a double is not working
                %for index
                Current_Stim_Object = this.Variable_Struct(1,1).List_of_stims(int8((current_opacity*10)+StimLeftOrRight));
                
            end
            
            
            %display stimulus
            Current_Stim_Object.DisplayOnScreen(1, this.Setting_Struct(1,1).Stimulussize_y, this.Setting_Struct(1,1).Stimulussize_x, this.Setting_Struct(1,1).Stimulusposition_x, this.Setting_Struct(1,1).Stimulusposition_y, this.Setting_Struct(1,1).Orientation);
            %add stim on to Stim events
            this.Data_Object.addStimEvent(StimLeftOrRight);
            
            %turn on LED
            this.SetLED(this.Variable_Struct(1,1).a, this.Setting_Struct(1,1).LED, 1);
            %let Matlab catch up
            pause(0.01);
            
        end
        
        
        function ShowCue(this, current_task, stim_type)
            %select stim by making new stimulus object
            %initialize by subracting 8 from the type, as id for
            %the cue is -2 for circle and -1 for contour
            set(this.Setting_Struct(1,1).GuiHandles.text1,'String','Showing Cue');
            pause(0.01); %refresh gui
            %pick cue depending of if two tasks or onw
            
            if current_task == 1
                Current_Cue_Object = BehaviorBoxVisualStimulus((stim_type) -8 , 0, 0 ,this.Setting_Struct(1,1).Input_type);
            else
                Current_Cue_Object = BehaviorBoxVisualStimulus((stim_type) -8 , 0, 0 ,this.Setting_Struct(1,1).Input_type);
            end
            
            %display stimulus
            Current_Cue_Object.DisplayOnScreen(1, this.Setting_Struct(1,1).Stimulussize_y, this.Setting_Struct(1,1).Stimulussize_x, this.Setting_Struct(1,1).Stimulusposition_x, this.Setting_Struct(1,1).Stimulusposition_y, this.Setting_Struct(1,1).Orientation);
            %wait for cue time
            pause(this.Setting_Struct(1,1).CueDuration)
            %close stim
            Current_Cue_Object.DisplayOnScreen(0, this.Setting_Struct(1,1).Stimulussize_y, this.Setting_Struct(1,1).Stimulussize_x, this.Setting_Struct(1,1).Stimulusposition_x, this.Setting_Struct(1,1).Stimulusposition_y, this.Setting_Struct(1,1).Orientation);
            %wait after cue
            pause(this.Setting_Struct(1,1).WaitAfterCue)
            
        end
        
        function [current_task_out] = set_current_task(this, current_task)
            
            current_task_out = current_task;
            
            if this.Setting_Struct(1,1).RandTaskAlt == 1
                %random
                if rand(1)>0.5 %right
                    current_task_out = 1;
                else %left
                    current_task_out = 0;
                end
                
            else
                %alternate
                this.counter_for_alternate_2_tasks = this.counter_for_alternate_2_tasks+1;
                
                %pick random number between range given
                randNum = floor(rand()*(this.Setting_Struct.MaxTaskAlt-this.Setting_Struct.MinTaskAlt)+this.Setting_Struct.MinTaskAlt);
                
                %if counter is larger than the random number, change side
                if this.counter_for_alternate_2_tasks > randNum
                    
                    if current_task == 1
                        this.counter_for_alternate_2_tasks = 0;
                        current_task_out = 0;
                    else
                        this.counter_for_alternate_2_tasks = 0;
                        current_task_out = 1;
                    end
                    
                end
                
            end
            
        end
        
        
        
        %before each trial, pick which side is correct
        function [StimLeftOrRight,isLeftTrial] = PickSideForCorrect(this,StimLeftOrRight,isLeftTrial, i)
            
            %if set to repeat wrong, do so
            if this.Setting_Struct(1,1).Repeat_wrong==1
                %check if last was wrong
                if i>1
                    if this.Data_Object.WhatWasPrevResponse() == 3 || this.Data_Object.WhatWasPrevResponse() ==4
                        %if was wrong, do nothing, leave current side to repeat
                        
                        
                    else %if first trial
                        %pick random side
                        if rand(1)>0.5 %right
                            StimLeftOrRight= 1;
                            isLeftTrial = 1;
                        else %left
                            StimLeftOrRight= 12;
                            isLeftTrial = 0;
                        end
                    end
                    
                end
                
            else %if not set to repeat wrong
                
                %pick random side
                if rand(1)>0.5 %right
                    StimLeftOrRight= 1;
                    isLeftTrial = 1;
                else
                    StimLeftOrRight= 12;
                    isLeftTrial = 0;
                end
            end
            
            
            %if specific left or right is required, overwrite
            if this.Setting_Struct(1,1).Stimulus_side > 1
                
                switch this.Setting_Struct(1,1).Stimulus_side
                    
                    case 2
                        %all left
                        StimLeftOrRight= 12;
                        isLeftTrial = 0;
                        
                    case 3
                        %all right
                        StimLeftOrRight= 1;
                        isLeftTrial = 1;
                        
                        
                        
                    case 4
                        
                        %alternate
                        this.counter_for_alternate = this.counter_for_alternate+1;
                        
                        %pick random number between range given
                        randNum = floor(rand()*(this.Setting_Struct.MaxRandAlt-this.Setting_Struct.MinRandAlt)+this.Setting_Struct.MinRandAlt);
                        
                        %if counter is larger than the random number, change side
                        if this.counter_for_alternate > randNum
                            
                            if strcmp(this.current_side,'right') == 1
                                this.counter_for_alternate = 0;
                                this.current_side = 'left';
                            else
                                this.counter_for_alternate = 0;
                                this.current_side = 'right';
                            end
                            
                        end
                        
                        %now choose depending on current
                        if strcmp(this.current_side,'right') %right
                            StimLeftOrRight= 1;
                            isLeftTrial = 1;
                        else %left
                            StimLeftOrRight= 12;
                            isLeftTrial = 0;
                            
                        end
                        
                        
                        
                end
                
                
            end
            
        end
        
        
        
        function cleanUp(this, Current_Stim_Object, Sound_start_Object)
            %switch on all buttons
            this.toggleButtonsOnOff(this.Setting_Struct,1);
            
            %turn off LED
            this.SetLED(this.Variable_Struct(1,1).a, this.Setting_Struct(1,1).LED, 0);
            
            %turn off sound
            if this.Setting_Struct(1,1).Play_sound
                stop(Sound_start_Object);
            end
            
            
            %close stimulus if still open
            try
                if this.Setting_Struct(1,1).Show_two_bars==1
                    Current_Stim_Object.DisplayOnScreen(0, this.Setting_Struct(1,1).Stimulussize_y,this.Setting_Struct(1,1).Stimulussize_x, this.Setting_Struct(1,1).Stimulusposition_x, this.Setting_Struct(1,1).Stimulusposition_y, this.Setting_Struct(1,1).Orientation);
                    
                end
            catch err
                
            end
            %print end time
            set(this.Setting_Struct(1,1).GuiHandles.pushbutton2,'Value', 0);
            disp_string = ['Stopped training Mouse ',this.Setting_Struct(1,1).Animal_ID, ' at ',datestr(now)];
            disp(disp_string);
            disp('- - - - -');
            
            
        end
        
        %overrides super function plotData
        function plotData(this)
            
            
            
            %plot activity
            %get data
            [x_all, y_activityCorrectWrong, y_Difficulty] = this.Data_Object.GetActivityCorrectWrongTimeoutDiff();
            if ~isempty(x_all)
                %if more than 200 minutes have been recorded, change scale
                %to hours
                if max(x_all) > 200
                    
                    x_all_mod = x_all/60;
                    set(this.Setting_Struct(1,1).GuiHandles.text93,'String', 'hours');
                else
                    
                    x_all_mod = x_all;
                    set(this.Setting_Struct(1,1).GuiHandles.text93,'String', 'minutes');
                    
                end
                
                
                
                %set the handle
                axes(this.Setting_Struct.GuiHandles.axes4);
                
                
                %plot
                hs=scatter(x_all, y_activityCorrectWrong,5,'filled');
                %set(hs,'MarkerFaceColor','c');
                %alpha(hs,.5);
                
                hold on
                p = plot(x_all, y_Difficulty);
                % p = plot(x_all, y_Difficulty(1:length(x_all)));
                set(p,'Color','red','LineWidth',2);
                hold off
                ylim([0 1]);
                set(gca,'YAxisLocation','right');
                %set(gca, 'YTick', []);
            end
            
            
            %get correct, wrong, difficulty without time spacing
            [x_left, x_right, y_left, y_right, x_left2, x_right2, y_left2, y_right2, difficulty_l_r,  all_responses_x, all_responses_y] = this.Data_Object.GetCorrectWrongLeftRight();
            %if data
            try
                if ~isempty(difficulty_l_r)
                    axes(this.Setting_Struct.GuiHandles.axes1);
                    
                    if  this.Setting_Struct(1,1).Stimulus_type == 8
                        hold on
                        if ~isempty(x_left)
                            %left 1 = cyan
                            bar(x_left, y_left, 1, 'm', 'EdgeColor','None');
                            ylim([0 1]);
                            hold on
                        end
                        
                        if ~isempty(x_right)
                            %right 1 = yellow
                            bar(x_right, y_right, 1, 'm','EdgeColor','None');
                            ylim([0 1]);
                            hold on
                        end
                        
                        
                        if ~isempty(x_left2)
                            %left 2 = cyan gray
                            bar(x_left2, y_left2, 1,  'w', 'EdgeColor','None');
                            ylim([0 1]);
                            hold on
                        end
                        
                        if ~isempty(x_right2)
                            %right 1 = yellow gray
                            bar(x_right2, y_right2, 1, 'w','EdgeColor','None');
                            ylim([0 1]);
                            hold on
                        end
                        
                        
                    else
                        
                        hold on
                        if ~isempty(x_left)
                            %left 1 = cyan
                            bar(x_left, y_left, 1, 'y', 'EdgeColor','None');
                            ylim([0 1]);
                            hold on
                        end
                        
                        if ~isempty(x_right)
                            %right 1 = yellow
                            bar(x_right, y_right, 1, 'c','EdgeColor','None');
                            ylim([0 1]);
                            hold on
                        end
                        
                    end
                    
                    %plot
                    p = plot(difficulty_l_r);
                    set(p,'Color','red','LineWidth',2);
                    ylim([0 1]);
                    hold on
                    scatter(all_responses_x, all_responses_y,5, [.5 0 0],'filled');
                    hold off
                    
                    xlim([0 this.Setting_Struct.GUI_numbers.trial_no]);
                    
                    
                    set(gca,'YAxisLocation','right');
                    %set(gca, 'YTick', []);
                    
                    
                end
            end
            
            %get binned performance (not used anymore in this version, but needs to be called first)
            this.Data_Object.GetBinnedPerformance(this.Setting_Struct.Pokes_to_generate_Percent, this.Setting_Struct(1,1).FirstBin_Size);
            
            %get further binned performance and plot
            [x_all, y_BinnedPerformance, y_BinnedPerformance_Error, y_Difficulty] = this.Data_Object.GetFurtherBinnedPerformance(this.Setting_Struct(1,1).FirstBin_Size, this.Setting_Struct(1,1).SecondBin_Size);
            
            if ~isempty(y_BinnedPerformance)
                axes(this.Setting_Struct.GuiHandles.axes2);
                
                %plot
                errorbar(x_all, y_BinnedPerformance,y_BinnedPerformance_Error);
                
                hold on
                p = plot(x_all, y_Difficulty);
                set(p,'Color','red','LineWidth',2);
                hold off
                ylim([0 1]);
                dispstring = ['Binned:',num2str(this.Setting_Struct(1,1).Pokes_to_generate_Percent*this.Setting_Struct(1,1).FirstBin_Size*this.Setting_Struct(1,1).SecondBin_Size),' trials/pt'];
                set(this.Setting_Struct(1,1).GuiHandles.text34,'String',dispstring);
                
            end
            
            
            
            
            
            
            
            %get performance per difficulty and plot (for random it needs
            %different function
            if this.Setting_Struct.Stimulus_type  ~= 9
                
                [x_all, y_PerformanceDifficulty, y_PerformanceDifficulty_Error, PerformanceDifficultyCount] = this.Data_Object.GetPerformanceDifficulty();
            else
                [x_all, y_PerformanceDifficulty, y_PerformanceDifficulty_Error, PerformanceDifficultyCount] = this.Data_Object.GetPerformanceDifficultyRandom();
                
                set(this.Setting_Struct(1,1).GuiHandles.text59,'String','(4) Perf/#Segms (data from 1)');
                
                
            end
            
            
            if ~isempty(y_PerformanceDifficulty)
                
                axes(this.Setting_Struct.GuiHandles.axes3);
                
                
                
                
                %plot
                errorbar(x_all, y_PerformanceDifficulty,y_PerformanceDifficulty_Error, 'bx');
                ylim([0 1]);
                xlim([-0.1 1.1]);
                
                if this.Setting_Struct.Stimulus_type  == 9
                    xlim([0 10]);
                end
                
                %array of all the counts per difficulty
                this.Setting_Struct(1,1).GUI_numbers.PerformanceDifficultyCount = PerformanceDifficultyCount;
                
                gui_numbers.Bin00=PerformanceDifficultyCount(1)*this.Setting_Struct.Pokes_to_generate_Percent;
                gui_numbers.Bin01=PerformanceDifficultyCount(2)*this.Setting_Struct.Pokes_to_generate_Percent;
                gui_numbers.Bin02=PerformanceDifficultyCount(3)*this.Setting_Struct.Pokes_to_generate_Percent;
                gui_numbers.Bin03=PerformanceDifficultyCount(4)*this.Setting_Struct.Pokes_to_generate_Percent;
                gui_numbers.Bin04=PerformanceDifficultyCount(5)*this.Setting_Struct.Pokes_to_generate_Percent;
                gui_numbers.Bin05=PerformanceDifficultyCount(6)*this.Setting_Struct.Pokes_to_generate_Percent;
                gui_numbers.Bin06=PerformanceDifficultyCount(7)*this.Setting_Struct.Pokes_to_generate_Percent;
                gui_numbers.Bin07=PerformanceDifficultyCount(8)*this.Setting_Struct.Pokes_to_generate_Percent;
                gui_numbers.Bin08=PerformanceDifficultyCount(9)*this.Setting_Struct.Pokes_to_generate_Percent;
                gui_numbers.Bin09=PerformanceDifficultyCount(10)*this.Setting_Struct.Pokes_to_generate_Percent;
                gui_numbers.Bin10=PerformanceDifficultyCount(11)*this.Setting_Struct.Pokes_to_generate_Percent;
                
                
                
            end
            
            %get response times of session
            [x_all_correct, y_BinnedResponses_correct, y_BinnedResponses_correct_error] = this.Data_Object.GetBinnedResponseTimesCorrect();
            [x_all_wrong, y_BinnedResponses_wrong, y_BinnedResponses_correct_wrong] = this.Data_Object.GetBinnedResponseTimesWrong();
            %get difficulties
            [x_resp_difficulties, y_resp_difficulties] = this.Data_Object.GetResponsesDifficulties();
            
            %plot response times of session
            axes(this.Setting_Struct.GuiHandles.axes5);
            if ~isempty(x_all_correct)
                %plot
                p = errorbar(x_all_correct, y_BinnedResponses_correct,y_BinnedResponses_correct_error);
                set(p,'Color','green','LineWidth',2);
            end
            if ~isempty(x_all_wrong)
                %plot
                hold on
                p = errorbar(x_all_wrong, y_BinnedResponses_wrong,y_BinnedResponses_correct_wrong);
                set(p,'Color','red','LineWidth',2);
                hold off
            end
            %             if ~isempty(x_all_wrong)
            %                 hold on
            %                 p = plot(x_resp_difficulties, y_resp_difficulties);
            %                 set(p,'Color','blue','LineWidth',2);
            %                 hold off
            %                 ylim([0 1]);
            %                 set(gca,'YAxisLocation','right');
            %               end
            
            %ylim([0 this.Setting_Struct(1,1).Timeout_after_time]);
            xlim([0 this.Setting_Struct.GUI_numbers.time]);
            
            %get response times histograms
            [x_histo_Correct, y_histo_Correct] = this.Data_Object.GetResponsesHistogramCorrect();
            [x_histo_Wrong, y_histo_Wrong] = this.Data_Object.GetResponsesHistogramWrong();
            %plot response times histogram of session
            
            axes(this.Setting_Struct.GuiHandles.axes6);
            
            if ~isempty(x_histo_Correct)
                % scatter(x_histo_Correct, y_histo_Correct,5, 'g','filled');
                bar(x_histo_Correct, y_histo_Correct, 1, 'g', 'EdgeColor','None');
            end
            if ~isempty(x_all_wrong)
                %plot
                hold on
                % scatter(x_histo_Wrong, y_histo_Wrong,5, 'r','filled');
                bar(x_histo_Wrong, y_histo_Wrong, 0.5, 'r', 'EdgeColor','None');
                hold off
            end
            
            
            
            
            %get total responses for gui update and show
            [TotalResponses] = this.Data_Object.GetTotalResponses();
            
            gui_numbers.left = TotalResponses(1);
            gui_numbers.right = TotalResponses(2);
            gui_numbers.rewards = TotalResponses(3);
            gui_numbers.total_correct = TotalResponses(4);
            
            
            %update data
            this.Setting_Struct.GUI_numbers = gui_numbers;
            
            
            
        end
        
    end
    
    
    
    %STATIC FUNCTIONS====
    methods(Static = true)
        
        
        function  [what_decision,response_time] = WaitForInputAndGiveReward(this, Current_Stim_Object, isLeftTrial, Sound_start_Object, Sound_correct_Object)
            %pass in handle to function to check if stop was pressed
            if isLeftTrial ==1
                side = 'left';
            else
                side = 'right';
            end
            set(this.Setting_Struct(1,1).GuiHandles.text1,'String',['Waiting for ',side,' response..']);
            pause(0.01);
            
            %play sound
            if this.Setting_Struct(1,1).Play_sound
                play(Sound_start_Object);
            end
            
            %abort function handle
            checkAbortHandle = @this.checkAbort;
            
            %start timer
            response_time_start = clock;
            
            
            %%%%
            %if using ball, wait for the same response to happend x amount
            %of times
            if this.Setting_Struct(1,1).Input_type == 4
                %make a counter for both left and right turns
                counter_left = 0;
                counter_right = 0;
                
                while 1
                    %if the times a turn has been detected is lager than
                    %the magnifier, break and take last as response
                    if counter_left > this.Setting_Struct(1,1).Rotation_magnifier-1
                        break;
                    end
                    
                    if counter_right > this.Setting_Struct(1,1).Rotation_magnifier-1
                        break;
                    end
                    
                    %if using ball, reset counter on connected arduino (set
                    %high)
                    if this.Setting_Struct(1,1).use_ball == 1
                        this.SetLED(this.Variable_Struct(1,1).a, this.Setting_Struct(1,1).ResetPin, 1);
                    end
                    pause(0.05);
                    %if using ball, reset counter on connected arduino (set
                    %low)
                    if this.Setting_Struct(1,1).use_ball == 1
                        this.SetLED(this.Variable_Struct(1,1).a, this.Setting_Struct(1,1).ResetPin, 0);
                    end
                    
                    
                    %get response
                    if this.Setting_Struct(1,1).ardunioReadDigital ==1
                        [what_decision] = this.readLeverLoopDigital(this.Variable_Struct(1,1).a, this.Setting_Struct.LeverA, this.Setting_Struct.LeverB, this.Setting_Struct.LeverC, this.Setting_Struct(1,1).Timeout_after_time, this.Setting_Struct.readHigh,this.Setting_Struct(1,1).GuiHandles.pushbutton2, this.Setting_Struct(1,1).GuiHandles.text1, checkAbortHandle, isLeftTrial);
                    else
                        [what_decision] = this.readLeverLoopAnalog(this.Variable_Struct(1,1).a, this.Setting_Struct.LeverA, this.Setting_Struct.LeverB, this.Setting_Struct.LeverC, this.Setting_Struct(1,1).Timeout_after_time, this.Setting_Struct.readHigh,this.Setting_Struct(1,1).GuiHandles.pushbutton2, this.Setting_Struct(1,1).GuiHandles.text1, checkAbortHandle, isLeftTrial);
                    end
                    
                    
                    %add to counter
                    if strcmp(what_decision , 'left correct') == 1
                        counter_left = counter_left+1;
                    end
                    if strcmp(what_decision , 'left wrong') == 1
                        counter_left = counter_left+1;
                    end
                    
                    
                    if strcmp(what_decision , 'right correct') == 1
                        counter_right = counter_right+1;
                    end
                    if strcmp(what_decision , 'right wrong') == 1
                        counter_right = counter_right+1;
                    end
                    
                    %if timeout, break
                    if strcmp(what_decision , 'time out') == 1
                        break;
                    end
                    
                    
                    if this.checkAbort(this.Setting_Struct(1,1).GuiHandles.pushbutton2,this.Setting_Struct(1,1).GuiHandles.text1)==1;
                        %abort
                        break;
                    end
                    
                    
                    
                    
                end
                
                %if not using ball
            else
                
                if this.Setting_Struct(1,1).ardunioReadDigital ==1
                    [what_decision] = this.readLeverLoopDigital(this.Variable_Struct(1,1).a, this.Setting_Struct.LeverA, this.Setting_Struct.LeverB, this.Setting_Struct.LeverC, this.Setting_Struct(1,1).Timeout_after_time, this.Setting_Struct.readHigh,this.Setting_Struct(1,1).GuiHandles.pushbutton2, this.Setting_Struct(1,1).GuiHandles.text1, checkAbortHandle, isLeftTrial);
                else
                    [what_decision] = this.readLeverLoopAnalog(this.Variable_Struct(1,1).a, this.Setting_Struct.LeverA, this.Setting_Struct.LeverB, this.Setting_Struct.LeverC, this.Setting_Struct(1,1).Timeout_after_time, this.Setting_Struct.readHigh,this.Setting_Struct(1,1).GuiHandles.pushbutton2, this.Setting_Struct(1,1).GuiHandles.text1, checkAbortHandle, isLeftTrial);
                end
                
                
            end
            
            response_time = etime(clock, response_time_start);
            
            
            
            %turn off LED
            this.SetLED(this.Variable_Struct(1,1).a, this.Setting_Struct(1,1).LED, 0);
            
            %stop sound
            if this.Setting_Struct(1,1).Play_sound
                stop(Sound_start_Object);
            end
            
            
            %close stimulus
            Current_Stim_Object.DisplayOnScreen(0, this.Setting_Struct(1,1).Stimulussize_y,this.Setting_Struct(1,1).Stimulussize_x, this.Setting_Struct(1,1).Stimulusposition_x, this.Setting_Struct(1,1).Stimulusposition_y, this.Setting_Struct(1,1).Orientation);
            %add stim on to Stim events
            this.Data_Object.addStimEvent(-1);
            
            %give reward if correct choice
            if  strcmp(what_decision , 'left correct') == 1 ||  strcmp(what_decision , 'right correct') == 1
                
                %play sound
                if this.Setting_Struct(1,1).Play_sound
                    play(Sound_correct_Object);
                end
                
                set(this.Setting_Struct(1,1).GuiHandles.text1,'String',[what_decision,' - Giving Reward...']);
                this.GiveReward(this.Variable_Struct(1,1).a,this.Setting_Struct(1,1).Valve, this.Setting_Struct(1,1).Valve_second,this.Setting_Struct(1,1).Valve_open_time, this.Setting_Struct(1,1).ValveB_open_time, this.Setting_Struct(1,1).Reward_pulse_num, this.Setting_Struct(1,1).Reward_pulses, this.Setting_Struct(1,1).Two_ports,what_decision);
                set(this.Setting_Struct(1,1).GuiHandles.text1,'String','intertrial interval..');
                
            end
            
            if  strcmp(what_decision , 'time out') == 1
                set(this.Setting_Struct(1,1).GuiHandles.text1,'String',[what_decision,' - proceed to next trial']);
                
            end
            
            
        end
        
        %read the input devices
        function [what_decision] = readLeverLoopDigital(a, LeverA, LeverB, LeverC, timeout_value, readHigh, stop_handle, message_handle, checkAbortHandle, isLeftTrial, stimuli, animate_stim, animate_speed)
            
            %returns -1 in case of timeout, 1 in case of LeverA, 2 for B
            %and 3 for C,
            
            start_time = clock;
            event = -1;
            
            if readHigh == 1
                threshold_read = 1;
            else
                threshold_read = 0;
            end
            
            
            %run loop that reads until timeout
            
            while etime(clock, start_time)<timeout_value
                
                %check if stop pressed
                if checkAbortHandle(stop_handle,message_handle)==1;
                    %abort
                    break;
                end
                
                if a.digitalRead(LeverA) == threshold_read
                    
                    %beam A broken
                    event = 1;
                    break
                elseif a.digitalRead(LeverB) == threshold_read
                    
                    %beam B broken
                    event = 2;
                    break
                    %inactivate center poke when waiting for decision
                    %                 elseif a.digitalRead(LeverC) == threshold_read
                    %
                    %                     %beam C broken
                    %                     event = 3;
                    %                     break
                end
                
                
                
            end
            
            
            %translate response to decision
            switch event
                
                case -1
                    
                    what_decision = 'time out';
                    
                case 1
                    
                    %-1 is for trainingstrials always correct
                    if isLeftTrial ==1 ||isLeftTrial == -1
                        what_decision = 'left correct';
                        
                    else
                        what_decision = 'left wrong';
                        
                    end
                    
                case 2
                    
                    if isLeftTrial ==0 ||isLeftTrial == -1
                        what_decision = 'right correct';
                        
                    else
                        what_decision = 'right wrong';
                        
                    end
                    
                case 3
                    set(message_handle,'String','Center Poke');
                    what_decision = 'center poke';
                    
            end
            
        end
        
        
        
        
        %save data when done
        function SaveAllData(this, GUI_handle)
            
            %change setting to save name
            switch this.Setting_Struct(1,1).Stimulus_type
                case 1
                    str_stim = 'ContourCrude';
                case 2
                    str_stim = 'ContourFine';
                case 3
                    str_stim = 'SquareBoxCrude';
                case 4
                    str_stim = 'SquareBoxFine';
                case 5
                    str_stim = 'MatchTarget';
                case 6
                    str_stim = 'Vernier';
                case 7
                    str_stim = 'Distractor';
                case 8
                    str_stim = '2TaskBoth';
                case 9
                    str_stim = 'Psychophy';
                case 10
                    str_stim = 'Grating';
            end
            
            switch this.Setting_Struct(1,1).Input_type
                case 1
                    str_input = 'OneLever';
                case 2
                    str_input = 'TwoLevers';
                case 3
                    str_input = 'ThreePokes';
                case 4
                    str_input = 'Ball';
                    
                    
            end
            
            %generate Save name
            saveasname = [datestr(this.Data_Object.start_time,'yymmdd_HHMMSS_'),this.Setting_Struct(1,1).Animal_ID,'_',num2str(this.Setting_Struct(1,1).File_Extension),'_',str_stim,str_input,'_FIG','.jpg'];
            
            %show in GUI
            gui_save_string = [datestr(this.Data_Object.start_time,'yymmdd_HHMMSS_'),this.Setting_Struct(1,1).Animal_ID,'_',num2str(this.Setting_Struct(1,1).File_Extension)];
            set(this.Setting_Struct(1,1).GuiHandles.text1,'String',gui_save_string);
            %update GUI
            pause(0.01)
            
            %save GUI as image
            set(GUI_handle,'PaperPositionMode','auto');
            set(gcf,'InvertHardcopy','off');
            print ('-dbmp', '-r400', saveasname);
            dispstring = ['Image saved as: ', saveasname];
            disp(dispstring);
            
            
            %save correct, wrong, timeout, difficulty, stim events
            %get data
            [x_all, y_activityCorrectWrong, y_Difficulty] = this.Data_Object.GetActivityCorrectWrongTimeoutDiff();
            %save stim on left (11), stif on right (1), stim off (-1)
            [x_allStim, y_StimOnOff] = this.Data_Object.GetStimOnOff();
            
            
            %only save if data
            if ~isempty(x_allStim)
                %fill length of vector to match for concatenation
                x_all(numel(x_allStim)) = 0;
                y_activityCorrectWrong(numel(x_allStim)) = 0;
                y_Difficulty(numel(x_allStim)) = 0;
                
                BehaviorData = [x_all;y_activityCorrectWrong;y_Difficulty;x_allStim;y_StimOnOff];
                saveasname = [datestr(this.Data_Object.start_time,'yymmdd_HHMMSS_'),this.Setting_Struct(1,1).Animal_ID,'_',num2str(this.Setting_Struct(1,1).File_Extension),'_',str_stim,str_input,'_xtime-act-diff-xtime-stimevents'];
                save(saveasname,'BehaviorData');
                dispstring = ['Data saved as: ', saveasname];
                disp(dispstring);
            end
            
            
            %if autoincrement file name
            if this.Setting_Struct(1,1).Increment_file
                this.Setting_Struct(1,1).File_Extension = this.Setting_Struct(1,1).File_Extension+1;
                set(this.Setting_Struct(1,1).GuiHandles.edit31,'String', num2str(this.Setting_Struct(1,1).File_Extension));
            end
            
            
        end
        
        
        
        function GiveReward(a, Valve, Valve_second, Time, TimeB, Pulse_no, Pulse_yesno, two_ports, side)
            
            %single reward
            if Pulse_yesno == 0
                
                if two_ports == 0
                    a.digitalWrite(Valve,1)
                    pause(Time);
                    a.digitalWrite(Valve,0)
                    
                else
                    %if left correct
                    if  strcmp(side , 'left correct') == 1
                        a.digitalWrite(Valve,1)
                        pause(Time);
                        a.digitalWrite(Valve,0)
                        
                    else %right
                        
                        a.digitalWrite(Valve_second,1)
                        pause(TimeB);
                        
                        a.digitalWrite(Valve_second,0)
                        
                    end
                end
                
            else %pulse reward
                
                for i = 1:Pulse_no
                    if two_ports == 0
                        a.digitalWrite(Valve,1)
                        pause(Time);
                        a.digitalWrite(Valve,0)
                        pause(1);
                        
                    else
                        %if left correct
                        if  strcmp(side , 'left correct') == 1
                            a.digitalWrite(Valve,1)
                            pause(Time);
                            a.digitalWrite(Valve,0)
                            
                        else %right
                            
                            a.digitalWrite(Valve_second,1)
                            pause(TimeB);
                            
                            a.digitalWrite(Valve_second,0)
                            
                        end
                        pause(1);
                        
                    end
                end
            end
            
            
        end
        
        
    end
    
end
