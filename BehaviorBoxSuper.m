classdef BehaviorBoxSuper < handle
    %BehaviorBox Super class (Input Training)
    
    %====================================================================
    %Super Class for BehaviorBox Ver 1.4
    %This Class is called by the GUI BehaviorBox via RunTraining()and runs the Training
    %loop, reads levers, gives rewards, plots data, etc. It stores data in the BehaviorBoxData.
    
    %It interacts with class BehaviorBoxVisualStimulusTraining.m to create the
    %visual stimuli.
    
    %This is a superclass to BehaviorBoxSub1/2.
    
    %Meyer 2015/5
    
    %THIS FILE IS PART OF A SET OF FILES CONTAINING (ALL NEEDED):
    %BehaviorBox.fig
    %BehaviorBox.m
    %BehaviorBoxData.m
    %BehaviorBoxSub1.m
    %BehaviorBoxSub2.mAddDecision
    %BehaviorBoxSuper.m
    %BehaviorBoxVisualGratingObject.m
    %BehaviorBoxVisualStimulus.m
    %BehaviorBoxVisualStimulusTraining.m
    %====================================================================
    
    
    
    %object variables
    properties (SetAccess = protected)
        
        Variable_Struct;
        Setting_Struct;
        Data_Object;
        
    end
    
    
    
    methods
        
        %constructor
        function this = BehaviorBoxSuper(GUI_handles)
            
            %set up user inputs etc and check if correct
            this.SetUpSettings(GUI_handles)
            
            %turn off all buttons (this function is static, as it doesnt
            %change any data
            this.toggleButtonsOnOff(this.Setting_Struct,0);
            
            %set up variables and connect to ardunio. Check if error in
            %connection
            this.SetUpVariables();
            
            %set up configuration of levers, stims, etc
            this.getLeverSettings(this.Setting_Struct(1,1).Input_type);
            set(this.Setting_Struct(1,1).GuiHandles.text1,'String','Trial config generated..');
            
            %set up data storage object
            this.Data_Object = BehaviorBoxData();
            set(this.Setting_Struct(1,1).GuiHandles.text1,'String','Data Object created..');
            
        end
        
        
        
        % INTERFACE====
        function RunTraining(this)
            %the actual loop
            this.DoLoop();
            
        end
        
        
        
        %MEMBER FUNCTIONS====
        function SetUpSettings(this, GUI_handles)
            %get Gui user inputs, check if all values are ok if not, report
            try
                %this initialized Setting_Structure
                this.getGuiInputAsStruct(GUI_handles);
                this.Setting_Struct(1,1).GuiHandles = GUI_handles;
            catch err
                set(GUI_handles.text1,'String',err.message);
                rethrow(err)
            end
            
            set(this.Setting_Struct(1,1).GuiHandles.text1,'String','Settings set..');
        end
        
        
        
        %set up all variables
        function SetUpVariables(this)
            %set up all other settings
            set(this.Setting_Struct(1,1).GuiHandles.text1,'String','Connecting Arduino..');
            
            %try to connect to arduino, if fail, report
            try
                this.Variable_Struct = this.initialize_everything();
            catch err2
                set(this.Setting_Struct(1,1).GuiHandles.text1,'String','no ardunino connected');
                this.toggleButtonsOnOff(this.Setting_Struct,1);
                rethrow(err2);
            end
            
            set(this.Setting_Struct(1,1).GuiHandles.text1,'String','Variables set..');
        end
        
        
        
        %set hardware (arduino) parameters
        function getLeverSettings(this, Input_type)
            
            this.Setting_Struct(1,1).use_ball = 0;
            
            
            %set which levers is what and what the input setup is from
            %levers, etc
            this.Setting_Struct(1,1).LeverA = 2;
            this.Setting_Struct(1,1).LeverB = 7;
            this.Setting_Struct(1,1).LeverC = 3;
            this.Setting_Struct(1,1).ResetPin = 4;
            this.Setting_Struct(1,1).TriggerPin = 5;
            this.Setting_Struct(1,1).LED = 9;
            this.Setting_Struct(1,1).Valve = 8;
            this.Setting_Struct(1,1).Valve_second = 6;
            
            
            
            switch Input_type
                
                %One Lever
                case 1
                    this.Setting_Struct(1,1).ardunioReadDigital = 1;
                    this.Setting_Struct(1,1).readHigh = 0;
                    %Three Levers
                case 2
                    
                    this.Setting_Struct(1,1).ardunioReadDigital = 1;
                    this.Setting_Struct(1,1).readHigh = 1;
                    
                    %Three Pokes
                case 3
                    
                    this.Setting_Struct(1,1).ardunioReadDigital = 1;
                    this.Setting_Struct(1,1).readHigh = 0;
                    
                    %Rotating Ball
                case 4
                    
                    this.Setting_Struct(1,1).readHigh = 1;
                    this.Setting_Struct(1,1).ardunioReadDigital = 1;
                    this.Setting_Struct(1,1).use_ball = 1;
                    
            end
            
        end
        
        
        
        
        %Run the loop
        function DoLoop(this) %=====MAIN LOOP===========================
            disp('- - - - -');
            dbstop if error
            
            
            %set local variables
            stop_handle = this.Setting_Struct(1,1).GuiHandles.pushbutton2;
            message_handle = this.Setting_Struct(1,1).GuiHandles.text1;
            real_time = clock;
            
            GUI_handle = gcf; %current GUI handle for save
            
            %create sound objects
            if this.Setting_Struct(1,1).Play_sound
                Sound_start_Object = audioplayer(this.Variable_Struct(1,1).soundstart, 48000);
                Sound_correct_Object = audioplayer(this.Variable_Struct(1,1).soundcorrect, 48000);
            else
                %make dummy paramenter
                Sound_start_Object = 1;
                Sound_correct_Object = 1;
            end
            
            
            this.SetupBeforeLoop();
            
            % select stimulus depending on input device
            if this.Setting_Struct(1,1).Input_type == 1
                TrainingStimulus = BehaviorBoxVisualStimulusTraining(this.Setting_Struct(1,1).Stimulus_type,1,0,this.Setting_Struct(1,1).Input_type);
            else
                TrainingStimulus = BehaviorBoxVisualStimulusTraining(5,1,0,this.Setting_Struct(1,1).Input_type);
            end
            
            %wait for trigger to start experiment
            if this.Setting_Struct(1,1).Ext_trigger
                
                set(this.Setting_Struct(1,1).GuiHandles.text1,'String','Waiting for trigger to start..', 'BackgroundColor','blue');
                
                while this.Variable_Struct.a.digitalRead(this.Setting_Struct(1,1).TriggerPin)==0
                    %check if abort button is pressed
                    if this.checkAbort(stop_handle,this.Setting_Struct(1,1).GuiHandles.text1)==1;
                        %abort
                        break;
                    end
                    pause(0.01);
                end
                
                set(this.Setting_Struct(1,1).GuiHandles.text1, 'BackgroundColor',[0.94 0.94 0.94]);
                
            end
            
            
            %LOOP====
            %run loop
            for i =  1:this.Setting_Struct(1,1).Input_training_only
                
                %check if stop pressed
                if this.checkAbort(stop_handle,message_handle)==1
                    %abort
                    break;
                end
                
                %update GUI
                this.updateGUIbeforeIteration(i, real_time);
                
                %if using ball, reset counter on connected arduino (set high)
                if this.Setting_Struct(1,1).use_ball == 1
                    this.SetLED(this.Variable_Struct(1,1).a, this.Setting_Struct(1,1).ResetPin, 1);
                end
                %if using ball, reset counter on connected arduino (set low)
                if this.Setting_Struct(1,1).use_ball == 1
                    this.SetLED(this.Variable_Struct(1,1).a, this.Setting_Struct(1,1).ResetPin, 0);
                end
                
                
                %if initialize, wait for initializiation
                if this.Setting_Struct(1,1).Initialize_by_input == 1
                    this.WaitForInput(this);
                end
                
                 %ignore input if set
                if  this.Setting_Struct(1,1).Input_ignored ==1
                    set(this.Setting_Struct(1,1).GuiHandles.text1,'String',['Ignoring Input for ',num2str(this.Setting_Struct(1,1).Pokes_igonerd_time),' seconds..']);
                    
                    pause(this.Setting_Struct(1,1).Pokes_igonerd_time);
                    
                end
                
                
                
                %if using ball, reset counter on connected arduino (set high)
                if this.Setting_Struct(1,1).use_ball == 1
                    this.SetLED(this.Variable_Struct(1,1).a, this.Setting_Struct(1,1).ResetPin, 1);
                end
                
                %if using ball, reset counter on connected arduino (set low)
                if this.Setting_Struct(1,1).use_ball == 1
                    this.SetLED(this.Variable_Struct(1,1).a, this.Setting_Struct(1,1).ResetPin, 0);
                end
                
                %present stimulus
                this.PresentStimulus(TrainingStimulus);
                
                
                %wait for response or timeout (static, pass this and call
                %this
                [what_decision] = this.WaitForInputAndGiveReward(TrainingStimulus, Sound_start_Object, Sound_correct_Object);
                
                
                %add data and update gui
                this.UpdateData(i, what_decision);
                
                
                %check if stop pressed, and do not plot data if aborted
                if this.checkAbort(stop_handle,message_handle)==1;
                    %abort
                    break;
                else
                    %plot activity
                    this.plotData();
                end
                
                
                %wait for intertrial time only
                pause(this.Setting_Struct(1,1).Intertrial_time);
                
                
                
            end %END loop
            
            
            %save when done
            this.SaveAllData(this, GUI_handle);
            %clean up
            this.cleanUP(TrainingStimulus);
            
        end %=====END OF MAIN LOOP===========================
        
        
        
        
        %Set up parameters before loop
        function SetupBeforeLoop(this)
            
            %update gui
            this.setGuiNumbers(this.Setting_Struct(1,1).GuiHandles, this.Setting_Struct(1,1).GUI_numbers);
            this.clearAxes(this.Setting_Struct(1,1).GuiHandles);
            
            %print start time
            
            disp_string = ['Start trial Mouse ',this.Setting_Struct(1,1).Animal_ID, ' at ',datestr(now)];
            disp(disp_string);
        end
        
        
        
        %update GUI numbers before each trial
        function updateGUIbeforeIteration(this, i, real_time)
            %add local variables to Gui Numbers
            this.Setting_Struct.GUI_numbers.trial_no = i;
            
            this.Setting_Struct.GUI_numbers.time = etime(clock, real_time)/60;
            
            %update Gui window
            this.setGuiNumbers(this.Setting_Struct(1,1).GuiHandles, this.Setting_Struct(1,1).GUI_numbers);
        end
        
        
        
        %Present Training stimulus
        function PresentStimulus(this, TrainingStimulus)
            
            %turn on LED
            this.SetLED(this.Variable_Struct(1,1).a, this.Setting_Struct(1,1).LED, 1);
            set(this.Setting_Struct(1,1).GuiHandles.text1,'String','Waiting for activity..');
            
            %display stimulus only if two bars is ticked
            if this.Setting_Struct(1,1).Show_two_bars ==1
                TrainingStimulus.DisplayOnScreen(1, this.Setting_Struct(1,1).Stimulussize_y,this.Setting_Struct(1,1).Stimulussize_x, this.Setting_Struct(1,1).Stimulusposition_x, this.Setting_Struct(1,1).Stimulusposition_y, this.Setting_Struct(1,1).Orientation);
                set(this.Setting_Struct(1,1).GuiHandles.text1,'String','Stimulus, waiting for activity..');
                %let Matlab catch up
                pause(0.01);
            end
            
        end
        
        
        
        %wait loop while lever is read and open valves if correct
        function  [what_decision] = WaitForInputAndGiveReward(this, TrainingStimulus, Sound_start_Object, Sound_correct_Object)
            
            set(this.Setting_Struct(1,1).GuiHandles.text1,'String','Waiting for response..');
            pause(0.01);
            
            %play sound
            if this.Setting_Struct(1,1).Play_sound
                play(Sound_start_Object);
            end
            
            
            checkAbortHandle = @this.checkAbort;
            if this.Setting_Struct(1,1).ardunioReadDigital ==1
                %the loop that reads lever
                [what_decision] = this.readLeverLoopDigital(this.Variable_Struct(1,1).a, this.Setting_Struct.LeverA, this.Setting_Struct.LeverB, this.Setting_Struct.LeverC, this.Setting_Struct(1,1).Timeout_after_time, this.Setting_Struct.readHigh,this.Setting_Struct(1,1).GuiHandles.pushbutton2, this.Setting_Struct(1,1).GuiHandles.text1, checkAbortHandle, -1);
            else
                [what_decision] = this.readLeverLoopAnalog(this.Variable_Struct(1,1).a, this.Setting_Struct.LeverA, this.Setting_Struct.LeverB, this.Setting_Struct.LeverC, this.Setting_Struct(1,1).Timeout_after_time, this.Setting_Struct.readHigh,this.Setting_Struct(1,1).GuiHandles.pushbutton2, this.Setting_Struct(1,1).GuiHandles.text1, checkAbortHandle, -1);
            end
            
            
            %stop sound
            if this.Setting_Struct(1,1).Play_sound
                stop(Sound_start_Object);
            end
            
            
            %close stimulus
            if this.Setting_Struct(1,1).Show_two_bars==1
                TrainingStimulus.DisplayOnScreen(0, this.Setting_Struct(1,1).Stimulussize_y,this.Setting_Struct(1,1).Stimulussize_x, this.Setting_Struct(1,1).Stimulusposition_x, this.Setting_Struct(1,1).Stimulusposition_y, this.Setting_Struct(1,1).Stimulusposition_y);
            end  %add stim on to Stim events
            
            
            %if correct
            if  strcmp(what_decision , 'time out') ~= 1
                %play sound
                if this.Setting_Struct(1,1).Play_sound
                    play(Sound_correct_Object);
                end
                
                set(this.Setting_Struct(1,1).GuiHandles.text1,'String','Giving Reward...');
                
                
                %give reward
                this.GiveReward(this.Variable_Struct(1,1).a,this.Setting_Struct(1,1).Valve, this.Setting_Struct(1,1).Valve_second,this.Setting_Struct(1,1).Valve_open_time, this.Setting_Struct(1,1).Reward_pulse_num, this.Setting_Struct(1,1).Reward_pulses, this.Setting_Struct(1,1).Two_ports);
                
                
            end
            
        end
        
        
        
        %Update the data object
        function UpdateData(this, i, what_decision)
            
            %set difficulty to 0, as it is training and won't change
            current_difficulty = 0;
            %add decision event to data object
            %two tasks not used in training
            is_task_two = 0;
            this.Data_Object.AddDecision(what_decision, current_difficulty, 0, is_task_two);
            
            %add local variables to Gui Numbers
            this.Setting_Struct(1,1).GUI_numbers(1,1).trial_no = i;
            
            %update Gui window
            this.setGuiNumbers(this.Setting_Struct(1,1).GuiHandles, this.Setting_Struct(1,1).GUI_numbers);
            %plot activity
            
        end
        
        
        
        %when done, clean up
        function cleanUP(this,TrainingStimulus)
            
            %switch on all buttons
            this.toggleButtonsOnOff(this.Setting_Struct,1);
            
            %turn off LED
            this.SetLED(this.Variable_Struct(1,1).a, this.Setting_Struct(1,1).LED, 0);
            
            %close stimulus if still open
            if this.Setting_Struct(1,1).Show_two_bars==1
                TrainingStimulus.DisplayOnScreen(0, this.Setting_Struct(1,1).Stimulussize_y,this.Setting_Struct(1,1).Stimulussize_x, this.Setting_Struct(1,1).Stimulusposition_x, this.Setting_Struct(1,1).Stimulusposition_y, this.Setting_Struct(1,1).Stimulusposition_y);
                
            end
            
            %print end time
            set(this.Setting_Struct(1,1).GuiHandles.pushbutton2,'Value', 0);
            disp_string = ['Stopped training Mouse ',this.Setting_Struct(1,1).Animal_ID, ' at ',datestr(now)];
            disp(disp_string);
            disp('- - - - -');
        end
        
        
        
        %make stimuli
        function makeListOfStims(this)
            
            opact = 0;
  
            
            %create left trial stimulus object with different difficulty
            for i=1:11 %left trials
                
                if this.Setting_Struct(1,1).Stimulus_type==1
                    this.Variable_Struct(1,1).List_of_stims(i) =  BehaviorBoxVisualStimulus(1, 0, opact ,this.Setting_Struct(1,1).Input_type);
                elseif this.Setting_Struct(1,1).Stimulus_type==2
                    this.Variable_Struct(1,1).List_of_stims(i) =  BehaviorBoxVisualStimulus(2, 0, opact,this.Setting_Struct(1,1).Input_type);
                elseif this.Setting_Struct(1,1).Stimulus_type==3
                    this.Variable_Struct(1,1).List_of_stims(i) =  BehaviorBoxVisualStimulus(3, 0, opact,this.Setting_Struct(1,1).Input_type);
                elseif this.Setting_Struct(1,1).Stimulus_type==4
                    this.Variable_Struct(1,1).List_of_stims(i) =  BehaviorBoxVisualStimulus(4, 0, opact,this.Setting_Struct(1,1).Input_type);
                elseif this.Setting_Struct(1,1).Stimulus_type==5
                    this.Variable_Struct(1,1).List_of_stims(i) =  BehaviorBoxVisualStimulus(5, 0, opact,this.Setting_Struct(1,1).Input_type);
                elseif this.Setting_Struct(1,1).Stimulus_type==6
                    this.Variable_Struct(1,1).List_of_stims(i) =  BehaviorBoxVisualStimulus(6, 0, opact,this.Setting_Struct(1,1).Input_type);
                elseif this.Setting_Struct(1,1).Stimulus_type==7
                    this.Variable_Struct(1,1).List_of_stims(i) =  BehaviorBoxVisualStimulus(7, 0, opact,this.Setting_Struct(1,1).Input_type);
                elseif this.Setting_Struct(1,1).Stimulus_type==8
                    this.Variable_Struct(1,1).List_of_stims(i) =  BehaviorBoxVisualStimulus(6, 0, opact,this.Setting_Struct(1,1).Input_type);
                    this.Variable_Struct(1,1).List_of_stims2(i) =   BehaviorBoxVisualStimulus(7, 0, opact,this.Setting_Struct(1,1).Input_type);
                elseif this.Setting_Struct(1,1).Stimulus_type==9
                    this.Variable_Struct(1,1).List_of_stims(i) =  BehaviorBoxVisualStimulus(9, 0, opact,this.Setting_Struct(1,1).Input_type);
                 elseif this.Setting_Struct(1,1).Stimulus_type==10
                    this.Variable_Struct(1,1).List_of_stims(i) =  BehaviorBoxVisualStimulus(10, 0, opact,this.Setting_Struct(1,1).Input_type);
                    
                    
                    
                end
                
                
                opact=opact+0.1;
            end
            
            opact = 0;%right trials
            for i=12:22
                if this.Setting_Struct(1,1).Stimulus_type==1
                    this.Variable_Struct(1,1).List_of_stims(i) =  BehaviorBoxVisualStimulus(1, 1, opact,this.Setting_Struct(1,1).Input_type);
                elseif this.Setting_Struct(1,1).Stimulus_type==2
                    this.Variable_Struct(1,1).List_of_stims(i) =  BehaviorBoxVisualStimulus(2, 1, opact,this.Setting_Struct(1,1).Input_type);
                elseif this.Setting_Struct(1,1).Stimulus_type==3
                    this.Variable_Struct(1,1).List_of_stims(i) =  BehaviorBoxVisualStimulus(3, 1, opact,this.Setting_Struct(1,1).Input_type);
                elseif this.Setting_Struct(1,1).Stimulus_type==4
                    this.Variable_Struct(1,1).List_of_stims(i) =  BehaviorBoxVisualStimulus(4, 1, opact,this.Setting_Struct(1,1).Input_type);
                elseif this.Setting_Struct(1,1).Stimulus_type==5
                    this.Variable_Struct(1,1).List_of_stims(i) =  BehaviorBoxVisualStimulus(5, 1, opact,this.Setting_Struct(1,1).Input_type);
                elseif this.Setting_Struct(1,1).Stimulus_type==6
                    this.Variable_Struct(1,1).List_of_stims(i) =  BehaviorBoxVisualStimulus(6, 1, opact,this.Setting_Struct(1,1).Input_type);
                elseif this.Setting_Struct(1,1).Stimulus_type==7
                    this.Variable_Struct(1,1).List_of_stims(i) =  BehaviorBoxVisualStimulus(7, 1, opact,this.Setting_Struct(1,1).Input_type);
                 elseif this.Setting_Struct(1,1).Stimulus_type==8
                    this.Variable_Struct(1,1).List_of_stims(i) =  BehaviorBoxVisualStimulus(6, 1, opact,this.Setting_Struct(1,1).Input_type);
                    this.Variable_Struct(1,1).List_of_stims2(i) =   BehaviorBoxVisualStimulus(7, 1, opact,this.Setting_Struct(1,1).Input_type);
                 elseif this.Setting_Struct(1,1).Stimulus_type==9
                    this.Variable_Struct(1,1).List_of_stims(i) =  BehaviorBoxVisualStimulus(9, 1, opact,this.Setting_Struct(1,1).Input_type);
                elseif this.Setting_Struct(1,1).Stimulus_type==10
                    this.Variable_Struct(1,1).List_of_stims(i) =  BehaviorBoxVisualStimulus(10, 1, opact,this.Setting_Struct(1,1).Input_type);
                   
                end
                
                
                opact=opact+0.1;
            end
        end
        
        
        
        
        %get the GUI settings for the experiment, if out of range, report
        function getGuiInputAsStruct(this, handles)
            
            this.Setting_Struct = struct('Input_training_only',10);
            this.Setting_Struct(1,1).GuiHandles = handles;
            
            this.Setting_Struct(1,1).Input_training_only=floor(str2double(get(handles.edit1,'String')));
            if this.Setting_Struct(1,1).Input_training_only<0
                error('Error. "Input training only" must be bigger than 0')
            end
            
            this.Setting_Struct(1,1).Starting_opacity=str2double(get(handles.edit2,'String'));
            if  this.Setting_Struct(1,1).Starting_opacity<0 || this.Setting_Struct(1,1).Starting_opacity>1
                error('Error. "Start Opacity" must be between 0 and 1')
            end
            
            this.Setting_Struct(1,1).Valve_open_time=str2double(get(handles.edit9,'String'));
            if this.Setting_Struct(1,1).Valve_open_time<0
                error('Error. "Valve Open Time" must be bigger than 0')
            end
            
            this.Setting_Struct(1,1).ValveB_open_time=str2double(get(handles.edit47,'String'));
            if this.Setting_Struct(1,1).ValveB_open_time<0
                error('Error. "Valve 2 Open Time" must be bigger than 0')
            end
            
          
            this.Setting_Struct(1,1).Reward_pulse_num=floor(str2double(get(handles.edit11,'String')));
            if this.Setting_Struct(1,1).Reward_pulse_num<0
                error('Error. "Reward Pulses" must be bigger than 0')
            end
            
            this.Setting_Struct(1,1).Pokes_to_generate_Percent=floor(str2double(get(handles.edit16,'String')));
            if this.Setting_Struct(1,1).Pokes_to_generate_Percent<0
                error('Error. "Input Used %" must be bigger than 0')
            end
            
            this.Setting_Struct(1,1).Pokes_igonerd_time=floor(str2double(get(handles.edit12,'String')));
            if this.Setting_Struct(1,1).Pokes_igonerd_time<0
                error('Error. "Pokes Ignored" must be bigger than 0')
            end
            
            this.Setting_Struct(1,1).Max_trial_num=floor(str2double(get(handles.edit7,'String')));
            if this.Setting_Struct(1,1).Max_trial_num<0
                error('Error. "Max Trial Number" must be bigger than 0')
            end
            
            this.Setting_Struct(1,1).Penalty_time=floor(str2double(get(handles.edit6,'String')));
            if this.Setting_Struct(1,1).Penalty_time<0
                error('Error. "Penalty(s)/trial" must be bigger than 0')
            end
            
            
            this.Setting_Struct(1,1).Intertrial_time=floor(str2double(get(handles.edit8,'String')));
            if this.Setting_Struct(1,1).Intertrial_time<0
                error('Error. "Intertrial Interval" must be bigger than 0')
            end
            
            
            this.Setting_Struct(1,1).Timeout_after_time=floor(str2double(get(handles.edit10,'String')));
            if this.Setting_Struct(1,1).Timeout_after_time<0
                error('Error. "Timeout After(s)" must be bigger than 0')
            end
            
            this.Setting_Struct(1,1).Stimulusposition_x=floor(str2double(get(handles.edit19,'String')));
            if this.Setting_Struct(1,1).Stimulusposition_x<0
                error('Error. "Stimulus X" must be bigger than 0')
            end
            
            this.Setting_Struct(1,1).Stimulusposition_y=floor(str2double(get(handles.edit17,'String')));
            if this.Setting_Struct(1,1).Stimulusposition_y<0
                error('Error. "Stimulus Y" must be bigger than 0')
            end
            this.Setting_Struct(1,1).Stimulussize_x=floor(str2double(get(handles.edit20,'String')));
            if this.Setting_Struct(1,1).Stimulussize_x<0
                error('Error. "Stimulus Width" must be bigger than 0')
            end
            
            this.Setting_Struct(1,1).Stimulussize_y=floor(str2double(get(handles.edit21,'String')));
            if this.Setting_Struct(1,1).Stimulussize_y<0
                error('Error. "Stimulus Height" must be bigger than 0')
            end
            
            this.Setting_Struct(1,1).Animal_ID=(get(handles.edit13,'String'));
            
            this.Setting_Struct(1,1).FirstBin_Size=floor(str2double(get(handles.edit14,'String')));
            if this.Setting_Struct(1,1).FirstBin_Size<0
                error('Error. "Correct Bin Size" must be bigger than 0')
            end
            
            
            this.Setting_Struct(1,1).SecondBin_Size=floor(str2double(get(handles.edit15,'String')));
            if this.Setting_Struct(1,1).SecondBin_Size<0
                error('Error. "Further Bin Size" must be bigger than 0')
            end
            
            this.Setting_Struct(1,1).Arduino_Com=floor(str2double(get(handles.edit22,'String')));
            if this.Setting_Struct(1,1).Arduino_Com<0
                error('Error. "Arduino Com" must be bigger than 0')
            end
            
            this.Setting_Struct(1,1).RaiseDiffAfterBins=floor(str2double(get(handles.edit23,'String')));
            if this.Setting_Struct(1,1).RaiseDiffAfterBins<0
                error('Error. "Raise Difficulty After Bins" must be bigger than 0')
            end
            
            this.Setting_Struct(1,1).Ori_Repeats=floor(str2double(get(handles.edit25,'String')));
            if this.Setting_Struct(1,1).Ori_Repeats<0
                error('Error. "Orientation Repeats" must be bigger than 0')
            end
            
            this.Setting_Struct(1,1).Ori_Duration=floor(str2double(get(handles.edit26,'String')));
            if this.Setting_Struct(1,1).Ori_Duration<0
                error('Error. "Orientation Duration" must be bigger than 0')
            end
            
            this.Setting_Struct(1,1).Ori_Interval=floor(str2double(get(handles.edit28,'String')));
            if this.Setting_Struct(1,1).Ori_Interval<0
                error('Error. "Orientation Interval" must be bigger than 0')
            end
            
            this.Setting_Struct(1,1).Ori_Bar_Size=floor(str2double(get(handles.edit29,'String')));
            if this.Setting_Struct(1,1).Ori_Bar_Size<0
                error('Error. "Orientation Bar size" must be bigger than 0')
            end
            
            this.Setting_Struct(1,1).Ori_Frequency=(str2double(get(handles.edit30,'String')));
            if this.Setting_Struct(1,1).Ori_Frequency<0
                error('Error. "Orientation Frequency" must be bigger than 0')
            end
            
            this.Setting_Struct(1,1).File_Extension=(str2double(get(handles.edit31,'String')));
            if this.Setting_Struct(1,1).Ori_Frequency<0
                error('Error. "File Extention" must be a number and bigger than 0')
            end
            
            this.Setting_Struct(1,1).Orientation=(str2double(get(handles.edit32,'String')));
            if this.Setting_Struct(1,1).Orientation<0
                error('Error. "File Extention" must be a number and bigger than 0')
            end
            
          
            
            %create structure to save all settings
            Setting_Struct(1,1).Orientation=str2double(get(handles.edit32,'String'));
            
            this.Setting_Struct(1,1).Increment_file=get(handles.checkbox14,'Value');
            this.Setting_Struct(1,1).Two_ports=get(handles.checkbox15,'Value');
            this.Setting_Struct(1,1).Reward_pulses=get(handles.checkbox2,'Value');
            this.Setting_Struct(1,1).Repeat_wrong=get(handles.checkbox3,'Value');
            this.Setting_Struct(1,1).Input_ignored=get(handles.checkbox4,'Value');
            this.Setting_Struct(1,1).Initialize_by_input=get(handles.checkbox5,'Value');
            this.Setting_Struct(1,1).Show_two_bars=get(handles.checkbox6,'Value');
            this.Setting_Struct(1,1).Ext_trigger=get(handles.checkbox8,'Value');
            this.Setting_Struct(1,1).Play_sound=get(handles.checkbox9,'Value');
            this.Setting_Struct(1,1).Stimulus_type=get(handles.popupmenu1,'Value');
            this.Setting_Struct(1,1).Stimulus_side=get(handles.popupmenu5,'Value');
            this.Setting_Struct(1,1).Input_type=get(handles.popupmenu2,'Value');
            this.Setting_Struct(1,1).Rotation_magnifier=get(handles.popupmenu7,'Value');
            this.Setting_Struct(1,1).Ori_Orientations=get(handles.popupmenu4,'Value');
            this.Setting_Struct(1,1).Ori_Random=get(handles.checkbox13,'Value');
            this.Setting_Struct(1,1).animate_stim=get(handles.checkbox17,'Value');
            this.Setting_Struct(1,1).animate_speed=str2double(get(handles.edit34,'String'));
            this.Setting_Struct(1,1).DiffAdjustMethod=get(handles.popupmenu9,'Value');
            
            this.Setting_Struct(1,1).Raise_bg_with_perf=get(handles.checkbox1,'Value');
            this.Setting_Struct(1,1).Lower_bg_with_perf=get(handles.checkbox18,'Value');
            this.Setting_Struct(1,1).LowerDiffAfterBins=str2double(get(handles.edit35,'String'));
            this.Setting_Struct(1,1).RaiseThres=str2double(get(handles.edit37,'String'));
            this.Setting_Struct(1,1).LowerThres=str2double(get(handles.edit38,'String'));
            this.Setting_Struct(1,1).StepUpAfter=str2double(get(handles.edit39,'String'));
            this.Setting_Struct(1,1).RandomMax=str2double(get(handles.edit40,'String'));
            this.Setting_Struct(1,1).RandomStep=str2double(get(handles.edit41,'String'));
            this.Setting_Struct(1,1).RandomMin=str2double(get(handles.edit42,'String'));
            this.Setting_Struct(1,1).CueDuration=str2double(get(handles.edit44,'String'));
            this.Setting_Struct(1,1).WaitAfterCue=str2double(get(handles.edit45,'String'));
            this.Setting_Struct(1,1).RespTimeBin=str2double(get(handles.edit46,'String'));
            this.Setting_Struct(1,1).MinRandAlt=str2double(get(handles.edit48,'String'));
            this.Setting_Struct(1,1).MaxRandAlt=str2double(get(handles.edit49,'String'));
            this.Setting_Struct(1,1).MinTaskAlt=str2double(get(handles.edit50,'String'));
            this.Setting_Struct(1,1).MaxTaskAlt=str2double(get(handles.edit51,'String'));
            this.Setting_Struct(1,1).RandTaskAlt=get(handles.checkbox19,'Value');


       
            this.initializeGUINumberStruct();
            
            
        end
        
        
        
        %initialize the data displays of GUI
        function initializeGUINumberStruct(this)
            %initialize gui numbers
            this.Setting_Struct(1,1).GUI_numbers(1,1).trial_no = 0;
            this.Setting_Struct(1,1).GUI_numbers(1,1).choices = 0;
            this.Setting_Struct(1,1).GUI_numbers(1,1).difficulty = 0;
            this.Setting_Struct(1,1).GUI_numbers(1,1).Bin00 = 0;
            this.Setting_Struct(1,1).GUI_numbers(1,1).Bin01 = 0;
            this.Setting_Struct(1,1).GUI_numbers(1,1).Bin02 = 0;
            this.Setting_Struct(1,1).GUI_numbers(1,1).Bin03 = 0;
            this.Setting_Struct(1,1).GUI_numbers(1,1).Bin04 = 0;
            this.Setting_Struct(1,1).GUI_numbers(1,1).Bin05 = 0;
            this.Setting_Struct(1,1).GUI_numbers(1,1).Bin06 = 0;
            this.Setting_Struct(1,1).GUI_numbers(1,1).Bin07 = 0;
            this.Setting_Struct(1,1).GUI_numbers(1,1).Bin08 = 0;
            this.Setting_Struct(1,1).GUI_numbers(1,1).Bin09 = 0;
            this.Setting_Struct(1,1).GUI_numbers(1,1).Bin10 = 0;
            this.Setting_Struct(1,1).GUI_numbers(1,1).rewards = 0;
            this.Setting_Struct(1,1).GUI_numbers(1,1).left = 0;
            this.Setting_Struct(1,1).GUI_numbers(1,1).center = 0;
            this.Setting_Struct(1,1).GUI_numbers(1,1).right = 0;
            this.Setting_Struct(1,1).GUI_numbers(1,1).total_correct = 0;
            this.Setting_Struct(1,1).GUI_numbers(1,1).time = 0;
            
        end
        
        
        
        %initialize hardware, etc
        function [Variable_Struct] = initialize_everything(this)
            
            %initialize variables structure
            Variable_Struct = struct('Empty',0);
            
            
            %generate sound waves for Start Trial Time
            %time seconds (max timeout length)
            T=this.Setting_Struct(1,1).Timeout_after_time;
            %sample rate [Hz] Supported by SoundCard (16000,48000,96000,192000)
            Fs = 48000;
            %samples
            N = T*Fs;
            %samples vector
            t = 0 : 1/Fs : T;
            %Frequency [Hz] (mice hear from 1kHz to 70kHz
            Fn = 10000;
            %Signal
            Variable_Struct(1,1).soundstart = sin(Fn*2*pi*t);
            
            %generate sound waves for Correct Trial Time
            %time seconds (1s)
            T=1;
            %sample rate [Hz] Supported by SoundCard (16000,48000,96000,192000)
            Fs = 48000;
            %samples
            N = T*Fs;
            %samples vector
            t = 0 : 1/Fs : T;
            %Frequency [Hz] (mice hear from 1kHz to 70kHz
            Fn = 40000;
            %Signal
            Variable_Struct(1,1).soundcorrect = sin(Fn*2*pi*t);
            
            %generate sound waves for Cue show
            %time seconds (1s)
            T=1;
            %sample rate [Hz] Supported by SoundCard (16000,48000,96000,192000)
            Fs = 44000;
            %samples
            N = T*Fs;
            %samples vector
            t = 0 : 1/Fs : T;
            %Frequency [Hz] (mice hear from 1kHz to 70kHz
            Fn = 40000;
            %Signal
            Variable_Struct(1,1).soundcue = sin(Fn*2*pi*t);
            
            
            disp('Initializing Arduino...');
            
            %connect to ardunio
            Variable_Struct(1,1).a=arduino(['com',num2str(this.Setting_Struct(1,1).Arduino_Com)]);
            
            %Pins
            Variable_Struct(1,1).a.pinMode(2,'INPUT'); % connect to pin 2 analog input (a2)
            Variable_Struct(1,1).a.pinMode(3,'INPUT'); % connect to pin 3 analog input (a3)
            Variable_Struct(1,1).a.pinMode(4,'OUTPUT'); % connect to pin 4 analog input (a4)
            Variable_Struct(1,1).a.pinMode(5,'INPUT'); % connect to pin 5 digital output (5)
            Variable_Struct(1,1).a.pinMode(6,'OUTPUT'); % connect to pin 6 digital output (6)
            Variable_Struct(1,1).a.pinMode(7,'INPUT'); % connect to pin 7 digital output (7)
            Variable_Struct(1,1).a.pinMode(8,'OUTPUT'); % connect to pin 8 digital output (8)
            Variable_Struct(1,1).a.pinMode(9,'OUTPUT'); % connect to pin 9 digital output (9)
            Variable_Struct(1,1).a.pinMode(10,'OUTPUT'); % connect to pin 10 digital output (10)
            Variable_Struct(1,1).List_of_stims(22) = BehaviorBoxVisualStimulus(0,0,0,0);
            Variable_Struct(1,1).List_of_stims2(22) = BehaviorBoxVisualStimulus(0,0,0,0);
            
            
            
        end
        
        
        
        %plot the data
        function plotData(this)
            
            %plot activity
            %get data
            [x_all, y_activityCorrectWrong] = this.Data_Object.GetActivityCorrectWrongTimeoutDiff();
            
            axes(this.Setting_Struct.GuiHandles.axes4);
            %plot
            scatter(x_all,y_activityCorrectWrong,10);
            
            ylim([0 1]);
            set(gca,'YAxisLocation','right');
            
            
            %get total responses for gui update
            [TotalResponses] = this.Data_Object.GetTotalResponses();
            
            this.Setting_Struct.GUI_numbers.left = TotalResponses(1);
            this.Setting_Struct.GUI_numbers.right = TotalResponses(2);
            this.Setting_Struct.GUI_numbers.rewards = TotalResponses(3);
            this.Setting_Struct.GUI_numbers.total_correct = TotalResponses(3);
            
            
        end
        
    end
    
    
    
    %STATIC FUNCTIONS====
    methods(Static = true)
        
        
        %function that sets pins of arduino to high or low
        function SetLED(a, LED, highlow)
            try
                a.digitalWrite(LED,highlow);
            catch err
                disp(err);
                disp('LED output failed, time:');
                disp(datestr(now));
            end
        end
        
        
        
        %loop function that reads lever
        function  WaitForInput(this)
            
            LeverA = this.Setting_Struct.LeverA;
            LeverB = this.Setting_Struct.LeverB;
            LeverC = this.Setting_Struct.LeverC;
            LED = this.Setting_Struct.LED;
            stop_handle = this.Setting_Struct(1,1).GuiHandles.pushbutton2;
            if this.Setting_Struct.readHigh == 1
                threshold_read = 1;
            else
                threshold_read = 0;
            end
            
            a =  this.Variable_Struct(1,1).a;
            set(this.Setting_Struct(1,1).GuiHandles.text1,'String','Waiting for Trial initialization');
            pause(0.01); %refresh gui
            
            %turn on LED
            this.SetLED(this.Variable_Struct(1,1).a, LED, 1);
            LED_counter = 0;
            
            %just read levers directly and when one gets triggerered, break
            
            %if digital
            if this.Setting_Struct(1,1).ardunioReadDigital ==1
                
                while ~get(stop_handle,'Value')
                    
                    
                    if a.digitalRead(LeverA) == threshold_read
                        %beam A broken, only if not three pokes (as in three pokes you
                        %want only the center poke to initiate. If you use
                        %ball, either turn is fine
                        if this.Setting_Struct(1,1).Input_type ~= 3
                            this.SetLED(this.Variable_Struct(1,1).a, LED, 0);
                            break
                        end
                    end
                    if a.digitalRead(LeverB) == threshold_read
                        %beam B broken
                        if this.Setting_Struct(1,1).Input_type ~= 3
                            this.SetLED(this.Variable_Struct(1,1).a, LED, 0);
                            break
                        end
                    end
                    if a.digitalRead(LeverC) == threshold_read
                        %beam C broken (center beam)
                        this.SetLED(this.Variable_Struct(1,1).a, LED, 0);
                        break
                    end
                    pause(0.01);
                    
                    LED_counter = LED_counter+1;
                    if LED_counter == 10
                        this.SetLED(this.Variable_Struct(1,1).a, LED, 0);
                        LED_counter = -10;
                    elseif LED_counter == 0
                        this.SetLED(this.Variable_Struct(1,1).a, LED, 1);
                    end
                    
                    
                end
                
                
                
                
            else %if analog
                
                threshold_read = 400;
                
                %if high
                if this.Setting_Struct.readHigh == 1
                    %run as long as button 0 (not pressed)
                    while ~get(stop_handle,'Value')
                        
                        
                        if a.analogRead(LeverA) > threshold_read ||a.analogRead(LeverB) > threshold_read||a.analogRead(LeverC) > threshold_read
                            this.SetLED(this.Variable_Struct(1,1).a, LED, 0);
                            break;
                            
                        end
                        
                        %need pause for gui to check if changed made (button
                        %pressed)
                        pause(0.01);
                        
                    end
                    
                    %if low
                else
                    %check if stop pressed
                    while ~get(stop_handle,'Value')
                        
                        
                        if a.analogRead(LeverA) < threshold_read ||a.analogRead(LeverB) < threshold_read||a.analogRead(LeverC) < threshold_read
                            this.SetLED(this.Variable_Struct(1,1).a, LED, 0);
                            break;
                            
                        end
                        
                        pause(0.01);
                        
                    end
                    
                end
                
            end
            
            
        end
        
        
        
        %open reward valves
        function GiveReward(a, Valve, Valve_second, Time, Pulse_no, Pulse_yesno, two_ports)
            
            %single reward
            if Pulse_yesno == 0
                
                if two_ports == 0
                    a.digitalWrite(Valve,1)
                    pause(Time);
                    a.digitalWrite(Valve,0)
                    
                else
                    a.digitalWrite(Valve,1)
                    a.digitalWrite(Valve_second,1)
                    pause(Time);
                    a.digitalWrite(Valve,0)
                    a.digitalWrite(Valve_second,0)
                    
                end
                
            else %pulse reward
                
                for i = 1:Pulse_no
                    if two_ports == 0
                        a.digitalWrite(Valve,1)
                        pause(Time);
                        a.digitalWrite(Valve,0)
                        pause(1);
                        
                    else
                        a.digitalWrite(Valve,1)
                        a.digitalWrite(Valve_second,1)
                        pause(Time);
                        a.digitalWrite(Valve,0)
                        a.digitalWrite(Valve_second,0)
                        pause(1);
                        
                    end
                end
            end
            
        end
        
        
        
        %check if abort button is pressed and abort if needed
        function [abort] = checkAbort(stop_handle, message_handle)
            
            if get(stop_handle,'Value')
                %abort
                abort = 1;
            else
                abort = 0;
            end
        end
        
        
        
        %read the lever (digital read)
        function [what_decision] = readLeverLoopDigital(a, LeverA, LeverB, LeverC, timeout_value, readHigh, stop_handle, message_handle, checkAbortHandle, isLeftTrial)
            
            %returns -1 in case of timeout, 1 in case of LeverA, 2 for B and 3 for C
            
            try
                start_time = clock;
                event = -1;
                
                if readHigh == 1
                    threshold_read = 1;
                else
                    threshold_read = 0;
                end
                
                
                %run loop
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
                        
                        %inactivate center
                        %                     elseif a.digitalRead(LeverC) == threshold_read
                        %
                        %                         %beam C broken
                        %                         event = 3;
                        %                         break
                    end
                end
                
            catch err
                disp(err);
                disp('digital lever read failed, time:');
                disp(datestr(now));
            end
            
            
            %translate to decision enum
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
                    
                    
            end
            
        end
        
        
        
        
        %read the lever (analog read)
        function [what_decision] = readLeverLoopAnalog(a, LeverA, LeverB, LeverC, timeout_value, readHigh,stop_handle, message_handle, checkAbortHandle, isLeftTrial)
            
            try
                start_time = clock;
                
                %return -1 in case of timeout
                event = -1;
                threshold_read = 400;
                if readHigh == 1
                    
                    while etime(clock, start_time)<timeout_value
                        
                        %check if stop pressed
                        if checkAbortHandle(stop_handle,message_handle)==1;
                            %abort
                            break;
                        end
                        
                        
                        if a.analogRead(LeverA) > threshold_read
                            
                            %beam A broken
                            event = 1;
                            break
                        elseif a.analogRead(LeverB) > threshold_read
                            
                            %beam B broken
                            event = 2;
                            
                        elseif a.analogRead(LeverC) > threshold_read
                            
                            %beam C broken
                            event = 3;
                            
                        end
                    end
                    
                else
                    while etime(clock, start_time)<timeout_value
                        
                        %check if stop pressed
                        if checkAbortHandle(stop_handle,message_handle)==1;
                            %abort
                            break;
                        end
                        
                        
                        if a.analogRead(LeverA) < threshold_read
                            
                            %beam A broken
                            event = 1;
                            break
                        elseif a.analogRead(LeverB) < threshold_read
                            
                            %beam B broken
                            event = 2;
                            
                        elseif a.analogRead(LeverC) < threshold_read
                            
                            %beam C broken
                            event = 3;
                            
                        end
                    end
                    
                    
                end
                
                %if only one lever is requested, return one lever only
                if event ==2 ||  event ==3
                    if argin == 8
                        event = 1;
                        
                    end
                end
                
                
            catch err
                disp(err);
                disp('analog lever read failed, time:');
                disp(datestr(now));
            end
            
            %translate to decision enum
            switch event
                
                case -1
                    
                    what_decision = 'time out';
                    
                case 1
                    
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
                    
                    what_decision = 'center poke';
                    
                    
            end
        end
        
        
        
        %set GUI settings and numbers from save or when starting new
        function setGuiNumbers(handle_gui, GUI_numbers)
            
            
            %trial no, choices, diff
            set(handle_gui.text16,'String',num2str(GUI_numbers.trial_no));
            set(handle_gui.text17,'String',num2str(GUI_numbers.difficulty));
            
            %Bin/Diff
            set(handle_gui.text58,'String',num2str(GUI_numbers.Bin00));
            set(handle_gui.text47,'String',num2str(GUI_numbers.Bin01));
            set(handle_gui.text48,'String',num2str(GUI_numbers.Bin02));
            set(handle_gui.text49,'String',num2str(GUI_numbers.Bin03));
            set(handle_gui.text50,'String',num2str(GUI_numbers.Bin04));
            set(handle_gui.text51,'String',num2str(GUI_numbers.Bin05));
            set(handle_gui.text57,'String',num2str(GUI_numbers.Bin06));
            set(handle_gui.text52,'String',num2str(GUI_numbers.Bin07));
            set(handle_gui.text53,'String',num2str(GUI_numbers.Bin08));
            set(handle_gui.text54,'String',num2str(GUI_numbers.Bin09));
            set(handle_gui.text55,'String',num2str(GUI_numbers.Bin10));
            
            %resp left center right rewards total correct
            set(handle_gui.text28,'String',num2str(GUI_numbers.left));
            set(handle_gui.text26,'String',num2str(GUI_numbers.right));
            set(handle_gui.text25,'String',num2str(GUI_numbers.rewards));
            set(handle_gui.text30,'String',num2str(GUI_numbers.total_correct));
            
            %time
            set(handle_gui.text3,'String',num2str(GUI_numbers.time));
            
            %let Matlab update
            pause(0.01);
            
        end
        
        
        
        %clear plots
        function clearAxes(Setting_Struct)
            axes(Setting_Struct(1,1).axes1);
            cla;
            
            axes(Setting_Struct(1,1).axes2);
            cla;
            
            axes(Setting_Struct(1,1).axes3);
            cla;
            
            axes(Setting_Struct(1,1).axes4);
            cla;
            
        end
        
        
        
        
        %toggle GUI buttons active/inactive
        function toggleButtonsOnOff(Setting_Struct, on)
            if on == 1
                toggle = 'on';
                
            else
                toggle = 'off';
                
            end
            
            set(Setting_Struct(1,1).GuiHandles.pushbutton1,'Enable',toggle);
            set(Setting_Struct(1,1).GuiHandles.pushbutton3,'Enable',toggle);
            set(Setting_Struct(1,1).GuiHandles.pushbutton11,'Enable',toggle);
            set(Setting_Struct(1,1).GuiHandles.pushbutton18,'Enable',toggle);
            set(Setting_Struct(1,1).GuiHandles.pushbutton4,'Enable',toggle);
            set(Setting_Struct(1,1).GuiHandles.pushbutton6,'Enable',toggle);
            set(Setting_Struct(1,1).GuiHandles.pushbutton7,'Enable',toggle);
            set(Setting_Struct(1,1).GuiHandles.pushbutton8,'Enable',toggle);
            set(Setting_Struct(1,1).GuiHandles.pushbutton9,'Enable',toggle);
            set(Setting_Struct(1,1).GuiHandles.pushbutton10,'Enable',toggle);
            
        end
        
        
        
        %save all data
        function SaveAllData(this, GUI_handle)
            
            %change setting to save name
            switch this.Setting_Struct(1,1).Stimulus_type
                case 1
                    str_stim = 'ContourCrude';
                case 2
                    str_stim = 'ContourFine';
                case 3
                    str_stim = 'SquareOCrude';
                case 4
                    str_stim = 'SquareOFine';
                case 5
                    str_stim = 'Distractor';
                case 6
                    str_stim = '2TaskCircle';
                case 7
                    str_stim = '2TaskLine';
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
            
            %if one side only
            str_side = '_';
            if this.Setting_Struct(1,1).Stimulus_side > 1
                
                if this.Setting_Struct(1,1).Stimulus_side == 2
                    str_side = '_LEFT_ONLY_';
                else
                    str_side = '_RIGHT_ONLY_';
                end
            end
            
            
            %generate Save name
            saveasname = [datestr(this.Data_Object.start_time,'yymmdd_HHMMSS_'),this.Setting_Struct(1,1).Animal_ID,'_',num2str(this.Setting_Struct(1,1).File_Extension),'_',str_stim,str_input,str_side,'BEHAVIOR_FIG','.jpg'];
            
            %save GUI as image
            set(GUI_handle,'PaperPositionMode','auto');
            set(gcf,'InvertHardcopy','off');
            print ('-dbmp', '-r400', saveasname);
            
            %save responses
            %get data
            [x_all, y_activityCorrectWrong] = this.Data_Object.GetActivityCorrectWrongTimeoutDiff();
            
            %only save if data
            if ~isempty(x_all)
                
                BehaviorData = [x_all;y_activityCorrectWrong];
                saveasname = [datestr(this.Data_Object.start_time,'yymmdd_HHMMSS_'),this.Setting_Struct(1,1).Animal_ID,'_',num2str(this.Setting_Struct(1,1).File_Extension),'_',str_stim,str_input,'_xtime-act-TRAINING'];
                save(saveasname,'BehaviorData');
                dispstring = ['Data saved as: ', saveasname];
                disp(dispstring);
            end
            
            dispstring = ['Data saved as: ', saveasname];
            disp(dispstring);
            %show in GUI
            gui_save_string = [datestr(this.Data_Object.start_time,'yymmdd_HHMMSS_'),this.Setting_Struct(1,1).Animal_ID,'_',num2str(this.Setting_Struct(1,1).File_Extension)];
            set(this.Setting_Struct(1,1).GuiHandles.text1,'String',gui_save_string);
            
            %if autoincrement filename
            if this.Setting_Struct(1,1).Increment_file
                this.Setting_Struct(1,1).File_Extension = this.Setting_Struct(1,1).File_Extension+1;
                set(this.Setting_Struct(1,1).GuiHandles.edit31,'String', num2str(this.Setting_Struct(1,1).File_Extension));
            end
            
        end
    end
    
end



