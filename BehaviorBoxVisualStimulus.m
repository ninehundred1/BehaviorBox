classdef BehaviorBoxVisualStimulus
    %    % Displays the Stimulus. Ver1.0 First Parameters is either:
    
    
    
    %all these are private and static
    properties(GetAccess = 'private', SetAccess = 'private')
        % private read and write access
        l=7; %width of each lines %defaul 19
        segments=9; %number of segments of contoru 5
        dx=1;% this is the inital starting offset for the first line in each colum
        dy=4; %and each rows. Every other column gets shifted to form interleaved pattern
        cy=5;  %y start position of contour, from bottom
        cx=4;%x start position of countour, from right edge
        transparenttrigger=1; % if this is 1, make bar transpartent
        linesy=11; %how many lines in y 7
        linesx=17;%how many lines in x 11
        zoomfactor = 1;
        
    end
    
    
    
    properties(SetAccess = 'public', GetAccess = 'private')
        % define the properties of the class here, (like fields of a struct)
        trialID;
        show;
        opacity;
        StimulusType;
        Levertype;
    end
    
    
    
    
    methods
        % methods, including the constructor are defined in this block
        function this = BehaviorBoxVisualStimulus(StimulusType, trialID, opacity, Levertype)
            % class constructor
            if(nargin > 0)
                %left of right
                this.trialID = trialID;
                %background opacity
                this.opacity    = opacity;
                this.StimulusType =StimulusType;
                this.Levertype = Levertype;
            end
            
            
        end
        
        
        function previewStim(this, winheight,winwidth,winx,winy, Orient, preview_Stim_ID, opacity)
            
            preview_side  = 1;
            
            %open figure
            fig1=figure(100);
            
            %use same random number for all
            rand_array = zeros(1,1000);
            
            %fill with random numbers
            for rand_n = 1:1000
                rand_array(1,rand_n) = rand;
            end
            
            
            trialID = 1;
            display = 1;
            
            
            switch preview_Stim_ID
                %these are cue stimuli and not part of the actual tasks, so
                %put ahead
                case -2
                    ShowStimulusTwoTaskCircleCUE(trialID, opacity,display,winheight,winwidth,winx,winy, 1,Orient)
                case -1
                    ShowStimulusTwoTaskContourCUE(trialID, opacity,display,winheight,winwidth,winx,winy, 1,Orient)
                    
                case 1
                    ShowStimulusContour(trialID, opacity,display,winheight,winwidth,winx,winy, 0,Orient);
                case 2
                    ShowStimulusContour(trialID, opacity,display,winheight,winwidth,winx,winy, 1,Orient);
                case 3
                    ShowStimulusSquare(trialID, opacity,display,winheight,winwidth,winx,winy,1 ,Orient);
                case 4
                    ShowStimulusSquare(trialID, opacity,display,winheight,winwidth,winx,winy, 0,Orient);
                case 5
                    ShowStimulusContourDistractor(trialID,opacity,display,winheight,winwidth,winx,winy,1,Orient);
                case 6
                    ShowStimulusTwoTaskCircle(trialID, opacity,display,winheight,winwidth,winx,winy, 1,Orient)
                case 7
                    ShowStimulusTwoTaskContour(trialID, opacity,display,winheight,winwidth,winx,winy, 1,Orient)
                    
                case 9
                    ShowStimulusPsychometricContour(trialID, opacity,display,winheight,winwidth,winx,winy, 1,Orient)
                    
                case 10
                    ShowStimulusGrating(trialID, opacity,display,winheight,winwidth,winx,winy, 1,Orient);
              
                 case 11
                    ShowStimulusOnePatchContour(trialID, opacity,display,winheight,winwidth,winx,winy, 0,Orient);
                     case 12
                    ShowStimulusOnePatchContour(trialID, opacity,display,winheight,winwidth,winx,winy, 1,Orient);
              
            end
            
        end
        
        
        function DisplayOnScreen(this, display, winheight,winwidth,winx, winy, orientation)
            
            %fill window size parameters if not supplied
            
            switch nargin
                case 2
                    winheight = 300;
                    winwidth = 1000;
                    winx = 400;
                    winy = 300;
                    orientation = 85;
                    
                case 3
                    winwidth = 1000;
                    winx = 400;
                    winy = 300;
                    orientation = 85;
                case 4
                    winx = 400;
                    winy = 300;
                    orientation = 85;
                case 5
                    winy = 300;
                    orientation = 85;
                case 6
                    orientation = 85;
            end
            
            
            if this.StimulusType==-2
                ShowStimulusTwoTaskCircleCUE(this.trialID, this.opacity, display,winheight,winwidth,winx,winy,1,orientation)
            elseif this.StimulusType==-1
                ShowStimulusTwoTaskContourCUE(this.trialID, this.opacity, display,winheight,winwidth,winx,winy,1,orientation)
            elseif this.StimulusType==1
                if this.Levertype==1
                    ShowStimulusOnePatchContour(this.trialID, this.opacity, display,winheight,winwidth,winx,winy,0,orientation)
                else
                    ShowStimulusContour(this.trialID, this.opacity,display,winheight,winwidth,winx,winy, 0,orientation);
                end
            elseif this.StimulusType==2
                if this.Levertype==1
                    ShowStimulusOnePatchContour(this.trialID, this.opacity, display,winheight,winwidth,winx,winy,1,orientation)
                else
                    ShowStimulusContour(this.trialID, this.opacity,display,winheight,winwidth,winx,winy, 1,orientation);
                end
            elseif this.StimulusType==3
                
                ShowStimulusSquare(this.trialID, this.opacity,display,winheight,winwidth,winx,winy, 1,orientation);
                
            elseif this.StimulusType==4
                
                ShowStimulusSquare(this.trialID, this.opacity,display,winheight,winwidth,winx,winy, 0,orientation);
                
            elseif this.StimulusType==5
                
                ShowStimulusContourDistractor(this.trialID, this.opacity,display,winheight,winwidth,winx,winy, 1,orientation);
                
            elseif this.StimulusType==6
                
                ShowStimulusTwoTaskCircle(this.trialID,this.opacity,display,winheight,winwidth,winx,winy,1,orientation)
                
            elseif this.StimulusType==7
                ShowStimulusTwoTaskContour(this.trialID,this.opacity,display,winheight,winwidth,winx,winy,1,orientation)
                
            elseif this.StimulusType==9
                ShowStimulusPsychometricContour(this.trialID,this.opacity,display,winheight,winwidth,winx,winy,1,orientation)
              
                
            elseif this.StimulusType==10
                ShowStimulusGrating(this.trialID,this.opacity,display,winheight,winwidth,winx,winy,1,orientation)
                
                
            end
            
            
            
            
            
            
        end
        
        
        
        
        
    end
    
end

function ShowStimulusSquare(trialID, opacity, display, winheight,winwidth,winx,winy,crudetoggle,Orient)


fig1=figure(100);
%show yes or no
if display==1
    
    if crudetoggle==0
        %fine
        
        ContLength=3; % length of contour
        ContLengthHalf=ceil(ContLength/2); %half of the contour
        PatchSize=11; % size of patch, pick uneven
        PatchSizeHalf=floor(PatchSize/2); %half of the patch
        SegmLength=1.2; %length of sements
        BinSize=2; %size of bins
        SegmThick=7; %line thickness9
        SegmJitter= 0.3;% jitter of segments
        
    else
        %crude
        
        ContLength=3; % length of contour
        ContLengthHalf=ceil(ContLength/2); %half of the contour
        PatchSize=9; % size of patch, pick uneven
        PatchSizeHalf=floor(PatchSize/2); %half of the patch
        SegmLength=1.2; %length of sements
        BinSize=2; %size of bins
        SegmThick=9; %line thickness9
        SegmJitter= 0.3;% jitter of segments
        
    end
    
    
    Alpha=-25; %determines closeness of contour elements, set somewhere between [-30 30]
    %see Li & Gilbert 2002
    Alpha=(90+Alpha)/90;
    
    SegmX=zeros(2,PatchSize,PatchSize);
    SegmY=zeros(2,PatchSize,PatchSize);
    % make grid
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=i*BinSize;
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=j*BinSize;
        end
    end
    
    % turn grid around crossing with y-axis
    [SegmTheta,SegmRho] = cart2pol(zeros(2,PatchSize,PatchSize),SegmY);
    SegmTheta(SegmTheta>0)=SegmTheta(SegmTheta>0)/Alpha;
    SegmTheta(SegmTheta<0)=((SegmTheta(SegmTheta<0)+pi)/Alpha)-pi;
    [SegmXA,SegmY] = pol2cart(SegmTheta,SegmRho);
    SegmX=SegmX+SegmXA;
    
    % Draw background with the grid as center
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            angle=rand*180;
            
            if i==j  & i>-ContLengthHalf &i<ContLengthHalf %for contour segments (take center colum and then go along that)
                angle=45;
                X=[-SegmLength*0.1 SegmLength*0.9];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
                
                
            elseif i==j-1  & i>-ContLengthHalf &i<ContLengthHalf %for contour segments (take center colum and then go along that)
                angle=45;
                X=[-SegmLength*0.85 SegmLength*0.15];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
                
                
                
            elseif i==j+1  & i>-ContLengthHalf+1 &i<ContLengthHalf+1 %for contour segments (take center colum and then go along that)
                angle=45;
                % X=[-(SegmLength*0.4)+SegmLength (SegmLength*0.6)+SegmLength];
                X=[-(SegmLength*0.8) (SegmLength*0.2)];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
                
            else
                JX=SegmJitter*2*(rand-0.5); %introduce jitter on non contour segments only
                JY=SegmJitter*2*(rand-0.5);
                X=[-SegmLength/2 SegmLength/2]+JX;
                Y=[0 0]-JY;
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi;
                [X,Y] = pol2cart(Theta,Rho);
                
            end
            
            
            
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+X';
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+Y';
        end
    end
    
    
    %plot all line segments
    
    
    
    if trialID==1
        figu=subplot(1,2,2);
    else
        subplot(1,2,1);
    end
    
    
    set(gca,'color','black')
    set(gcf,'color','black')
    
    hold on;
    
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick,'Color',[1*opacity 1*opacity 1*opacity])
        end
    end
    
    hold on
    
    % Draw segments grid as center
    
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            
            
            
            if i==j  & i>-ContLengthHalf &i<ContLengthHalf & i~=ContLengthHalf %for contour segments (take center colum and then go along that)
                
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
                
                
            elseif i==j-1  & i>-ContLengthHalf &i<ContLengthHalf %for contour segments (take center colum and then go along that)
                
                
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
                
                
            elseif i==j+1  & i>-ContLengthHalf+1 &i<ContLengthHalf+1 %for contour segments (take center colum and then go along that)
                
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
                
                
            end
            
            
            
            
        end
        
    end
    
    
    
    hold off
    
    
    
    %plot mask, upper and lower part separate
    NumPoints=100;
    Radius=(PatchSizeHalf-2)*BinSize;
    Theta=linspace(0,pi,NumPoints); %100 evenly spaced points between 0 and pi
    Rho=ones(1,NumPoints)*Radius; %Radius should be 1 for all 100 points
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    Theta=linspace(0,-pi,NumPoints); %100 evenly spaced points between 0 and -pi
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=-PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=-PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    
    axis tight; axis square
    
    %
    % if trialID==1
    % view(-Orient/Alpha,90)
    % else
    %     view(-Orient+45/Alpha,90)
    % end
    view(-Orient/Alpha,90)
    
    xlim([-Radius*0.8 Radius*0.8])
    ylim([-Radius*0.8 Radius*0.8])
    
    % print -dbmp LiStim1
    
    
    % SECOND PART OF FOGURE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    hold on
    % make grid
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=i*BinSize;
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=j*BinSize;
        end
    end
    
    % turn grid around crossing with y-axis
    [SegmTheta,SegmRho] = cart2pol(zeros(2,PatchSize,PatchSize),SegmY);
    SegmTheta(SegmTheta>0)=SegmTheta(SegmTheta>0)/Alpha;
    SegmTheta(SegmTheta<0)=((SegmTheta(SegmTheta<0)+pi)/Alpha)-pi;
    [SegmXA,SegmY] = pol2cart(SegmTheta,SegmRho);
    SegmX=SegmX+SegmXA;
    
    % Draw background with the grid as center
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            angle=rand*180;
            
            if i==j  & i>-ContLengthHalf &i<ContLengthHalf & i  %for contour segments (take center colum and then go along that)
                angle=45;
                X=[-SegmLength*0.1 SegmLength*0.9];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
                
                
            elseif  i==j  & i>-ContLengthHalf &i<ContLengthHalf %make sure the center of O is not randomly filling patch (avoid 45)
                
                angle=rand*155+75;
                
                JX=SegmJitter*2*(rand-0.7); %introduce jitter on non contour segments only
                JY=SegmJitter*2*(rand-0.4);
                X=[-SegmLength*0.1 SegmLength*0.9]+JX-0.17;
                Y=[0 0]-JY-0.4;
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi;
                [X,Y] = pol2cart(Theta,Rho);
                
                
                
                
            elseif i==j-1  & i>-ContLengthHalf &i<ContLengthHalf %for contour segments (take center colum and then go along that)
                angle=45;
                X=[-SegmLength*0.85 SegmLength*0.15];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
                
                
                
            elseif i==j+1  & i>-ContLengthHalf+1 &i<ContLengthHalf+1 %for contour segments (take center colum and then go along that)
                angle=45;
                % X=[-(SegmLength*0.4)+SegmLength (SegmLength*0.6)+SegmLength];
                X=[-(SegmLength*0.8) (SegmLength*0.2)];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
                
            else
                JX=SegmJitter*2*(rand-0.5); %introduce jitter on non contour segments only
                JY=SegmJitter*2*(rand-0.5);
                X=[-SegmLength/2 SegmLength/2]+JX;
                Y=[0 0]-JY;
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi;
                [X,Y] = pol2cart(Theta,Rho);
                
            end
            
            
            
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+X';
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+Y';
        end
    end
    
    
    %plot all line segments
    
    
    
    if trialID==1
        figu=subplot(1,2,1);
    else
        subplot(1,2,2);
    end
    
    
    set(gca,'color','black')
    set(gcf,'color','black')
    
    hold on;
    
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick,'Color',[1*opacity 1*opacity 1*opacity])
        end
    end
    
    hold on
    
    % Draw segments grid as center
    
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            
            
            
            if i==j  & i>-ContLengthHalf &i<ContLengthHalf & i~=ContLengthHalf & i~=0%for contour segments (take center colum and then go along that)
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
                
                
            elseif i==j-1  & i>-ContLengthHalf &i<ContLengthHalf %for contour segments (take center colum and then go along that)
                
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
                
                
            elseif i==j+1  & i>-ContLengthHalf+1 &i<ContLengthHalf+1 %for contour segments (take center colum and then go along that)
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
                
                
            end
            
            
            
            
        end
        
    end
    
    
    
    hold off
    
    
    
    %plot mask, upper and lower part separate
    NumPoints=100;
    Radius=(PatchSizeHalf-2)*BinSize;
    Theta=linspace(0,pi,NumPoints); %100 evenly spaced points between 0 and pi
    Rho=ones(1,NumPoints)*Radius; %Radius should be 1 for all 100 points
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    Theta=linspace(0,-pi,NumPoints); %100 evenly spaced points between 0 and -pi
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=-PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=-PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    
    axis tight; axis square
    
    %
    % if trialID==1
    % view(-Orient/Alpha,90)
    % else
    %     view(-Orient+45/Alpha,90)
    % end
    view(-Orient/Alpha,90)
    
    xlim([-Radius*0.8 Radius*0.8])
    ylim([-Radius*0.8 Radius*0.8])
    
    pause(0.01);
    
    positionfig=[winx winy winwidth winheight];
    
    set(fig1,'OuterPosition',positionfig) ;%move window here, also determines size
    
else
    
    close(fig1);
    
end

end




function ShowStimulusContour(trialID, opacity, display, winheight,winwidth,winx,winy,crudetoggle,Orient)


fig1=figure(100);
if display==1
    
    if crudetoggle==0
        %fine
        
        ContLength=7; % length of contour
        ContLengthHalf=ceil(ContLength/2); %half of the contour
        PatchSize=9; % size of patch, pick uneven
        PatchSizeHalf=floor(PatchSize/2); %half of the patch
        SegmLength=1.2; %length of sements
        BinSize=2; %size of bins
        SegmThick=7; %line thickness9
        SegmJitter= 0.3;% jitter of segments
        
    else
        %crude
        
        ContLength=7; % length of contour
        ContLengthHalf=ceil(ContLength/2); %half of the contour
        PatchSize=11; % size of patch, pick uneven
        PatchSizeHalf=floor(PatchSize/2); %half of the patch
        SegmLength=1.2; %length of sements
        BinSize=2; %size of bins
        SegmThick=9; %line thickness9
        SegmJitter= 0.3;% jitter of segments
        
    end
    
    
    
    
    Alpha=-25; %determines closeness of contour elements, set somewhere between [-30 30]
    %see Li & Gilbert 2002
    Alpha=(90+Alpha)/90;
    
    SegmX=zeros(2,PatchSize,PatchSize);
    SegmY=zeros(2,PatchSize,PatchSize);
    % make grid
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=i*BinSize;
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=j*BinSize;
        end
    end
    
    % turn grid around crossing with y-axis
    [SegmTheta,SegmRho] = cart2pol(zeros(2,PatchSize,PatchSize),SegmY);
    SegmTheta(SegmTheta>0)=SegmTheta(SegmTheta>0)/Alpha;
    SegmTheta(SegmTheta<0)=((SegmTheta(SegmTheta<0)+pi)/Alpha)-pi;
    [SegmXA,SegmY] = pol2cart(SegmTheta,SegmRho);
    SegmX=SegmX+SegmXA;
    
    % Draw background with the grid as center
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            angle=rand*180;
            if i==j & i>-ContLengthHalf &i<ContLengthHalf %for contour segments
                angle=45;
                X=[-SegmLength/2 SegmLength/2];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
            else
                JX=SegmJitter*2*(rand-0.5); %introduce jitter on non contour segments only
                JY=SegmJitter*2*(rand-0.5);
                X=[-SegmLength/2 SegmLength/2]+JX;
                Y=[0 0]-JY;
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi;
                [X,Y] = pol2cart(Theta,Rho);
            end
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+X';
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+Y';
        end
    end
    
    
    %plot all line segments
    
    if trialID==1
        figu=subplot(1,2,2);
    else
        subplot(1,2,1);
    end
    
    
    set(gca,'color','black')
    set(gcf,'color','black')
    
    hold on;
    
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick,'Color',[1*opacity 1*opacity 1*opacity])
        end
    end
    
    hold on
    
    % Draw segments grid as center
    
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            
            if i==j & i>-ContLengthHalf &i<ContLengthHalf %for contour segments
                angle=45;
                X=[-SegmLength/2 SegmLength/2];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
            end
        end
        
    end
    
    
    
    hold off
    
    %plot mask, upper and lower part separate
    NumPoints=100;
    Radius=(PatchSizeHalf-2)*BinSize;
    Theta=linspace(0,pi,NumPoints); %100 evenly spaced points between 0 and pi
    Rho=ones(1,NumPoints)*Radius; %Radius should be 1 for all 100 points
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    Theta=linspace(0,-pi,NumPoints); %100 evenly spaced points between 0 and -pi
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=-PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=-PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    
    axis tight; axis square
    
    
    view(-Orient/Alpha,90)
    
    xlim([-Radius*0.8 Radius*0.8])
    ylim([-Radius*0.8 Radius*0.8])
    
    % print -dbmp LiStim1
    
    
    % SECOND PART OF FOGURE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    hold on
    % make grid
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=i*BinSize;
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=j*BinSize;
        end
    end
    
    % turn grid around crossing with y-axis
    [SegmTheta,SegmRho] = cart2pol(zeros(2,PatchSize,PatchSize),SegmY);
    SegmTheta(SegmTheta>0)=SegmTheta(SegmTheta>0)/Alpha;
    SegmTheta(SegmTheta<0)=((SegmTheta(SegmTheta<0)+pi)/Alpha)-pi;
    [SegmXA,SegmY] = pol2cart(SegmTheta,SegmRho);
    SegmX=SegmX+SegmXA;
    
    % Draw background with the grid as center
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            angle=rand*180;
            
            JX=SegmJitter*2*(rand-0.5); %introduce jitter on non contour segments only
            JY=SegmJitter*2*(rand-0.5);
            X=[-SegmLength/2 SegmLength/2]+JX;
            Y=[0 0]-JY;
            [Theta,Rho] = cart2pol(X,Y);
            Theta=Theta+angle/180*pi;
            [X,Y] = pol2cart(Theta,Rho);
            
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+X';
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+Y';
        end
    end
    
    
    %plot all line segments
    if trialID==1
        subplot(1,2,1);
    else
        subplot(1,2,2);
    end
    set(gca,'color','black')
    set(gcf,'color','black')
    
    hold on;
    
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick,'Color',[1*opacity 1*opacity 1*opacity])
        end
    end
    
    hold on
    
    hold off
    
    
    %plot mask, upper and lower part separate
    NumPoints=100;
    Radius=(PatchSizeHalf-2)*BinSize;
    Theta=linspace(0,pi,NumPoints); %100 evenly spaced points between 0 and pi
    Rho=ones(1,NumPoints)*Radius; %Radius should be 1 for all 100 points
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    Theta=linspace(0,-pi,NumPoints); %100 evenly spaced points between 0 and -pi
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=-PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=-PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    hold off
    axis tight; axis square
    view(-Orient/Alpha,90)
    xlim([-Radius*0.8 Radius*0.8])
    ylim([-Radius*0.8 Radius*0.8])
    set(gcf,'MenuBar','none');
    
    
    positionfig=[winx winy winwidth winheight];
    
    
    %positionfig=[1600 50 500 450];
    set(fig1,'OuterPosition',positionfig) ;%move window here, also determines size
    %notusedyet=borderwidth;
else
    
    close(fig1);
    
end

end




function ShowStimulusPsychometricContour(trialID, opacity, display, winheight,winwidth,winx,winy,crudetoggle,Orient)


fig1=figure(100);
if display==1
    
    
    if crudetoggle==0
        %fine
        
        ContLength=7; % length of contour
        ContLengthHalf=ceil(ContLength/2); %half of the contour
        PatchSize=9; % size of patch, pick uneven
        PatchSizeHalf=floor(PatchSize/2); %half of the patch
        SegmLength=1.2; %length of sements
        BinSize=2; %size of bins
        SegmThick=7; %line thickness9
        SegmJitter= 0.3;% jitter of segments
        
    else
        %crude
        
        ContLength=9-(opacity*20)-1; % length of contour
        ContLengthHalf=ceil(ContLength/2); %half of the contour
        PatchSize=11; % size of patch, pick uneven
        PatchSizeHalf=floor(PatchSize/2); %half of the patch
        SegmLength=1.2; %length of sements
        BinSize=2; %size of bins
        SegmThick=9; %line thickness9
        SegmJitter= 0.3;% jitter of segments
        
    end
    
    opacity = 1;
    
    Alpha=-25; %determines closeness of contour elements, set somewhere between [-30 30]
    %see Li & Gilbert 2002
    Alpha=(90+Alpha)/90;
    
    SegmX=zeros(2,PatchSize,PatchSize);
    SegmY=zeros(2,PatchSize,PatchSize);
    % make grid
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=i*BinSize;
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=j*BinSize;
        end
    end
    
    % turn grid around crossing with y-axis
    [SegmTheta,SegmRho] = cart2pol(zeros(2,PatchSize,PatchSize),SegmY);
    SegmTheta(SegmTheta>0)=SegmTheta(SegmTheta>0)/Alpha;
    SegmTheta(SegmTheta<0)=((SegmTheta(SegmTheta<0)+pi)/Alpha)-pi;
    [SegmXA,SegmY] = pol2cart(SegmTheta,SegmRho);
    SegmX=SegmX+SegmXA;
    
    % Draw background with the grid as center
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            angle=rand*180;
            if i==j & i>-ContLengthHalf &i<ContLengthHalf %for contour segments
                angle=45;
                X=[-SegmLength/2 SegmLength/2];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
            else
                JX=SegmJitter*2*(rand-0.5); %introduce jitter on non contour segments only
                JY=SegmJitter*2*(rand-0.5);
                X=[-SegmLength/2 SegmLength/2]+JX;
                Y=[0 0]-JY;
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi;
                [X,Y] = pol2cart(Theta,Rho);
            end
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+X';
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+Y';
        end
    end
    
    
    %plot all line segments
    
    if trialID==1
        figu=subplot(1,2,2);
    else
        subplot(1,2,1);
    end
    
    
    set(gca,'color','black')
    set(gcf,'color','black')
    
    hold on;
    
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick,'Color',[1*opacity 1*opacity 1*opacity])
        end
    end
    
    hold on
    
    % Draw segments grid as center
    
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            
            if i==j & i>-ContLengthHalf &i<ContLengthHalf %for contour segments
                angle=45;
                X=[-SegmLength/2 SegmLength/2];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
            end
        end
        
    end
    
    
    
    hold off
    
    %plot mask, upper and lower part separate
    NumPoints=100;
    Radius=(PatchSizeHalf-2)*BinSize;
    Theta=linspace(0,pi,NumPoints); %100 evenly spaced points between 0 and pi
    Rho=ones(1,NumPoints)*Radius; %Radius should be 1 for all 100 points
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    Theta=linspace(0,-pi,NumPoints); %100 evenly spaced points between 0 and -pi
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=-PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=-PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    
    axis tight; axis square
    
    
    view(-Orient/Alpha,90)
    
    xlim([-Radius*0.8 Radius*0.8])
    ylim([-Radius*0.8 Radius*0.8])
    
    % print -dbmp LiStim1
    
    
    % SECOND PART OF FOGURE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    hold on
    % make grid
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=i*BinSize;
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=j*BinSize;
        end
    end
    
    % turn grid around crossing with y-axis
    [SegmTheta,SegmRho] = cart2pol(zeros(2,PatchSize,PatchSize),SegmY);
    SegmTheta(SegmTheta>0)=SegmTheta(SegmTheta>0)/Alpha;
    SegmTheta(SegmTheta<0)=((SegmTheta(SegmTheta<0)+pi)/Alpha)-pi;
    [SegmXA,SegmY] = pol2cart(SegmTheta,SegmRho);
    SegmX=SegmX+SegmXA;
    
    % Draw background with the grid as center
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            angle=rand*180;
            
            JX=SegmJitter*2*(rand-0.5); %introduce jitter on non contour segments only
            JY=SegmJitter*2*(rand-0.5);
            X=[-SegmLength/2 SegmLength/2]+JX;
            Y=[0 0]-JY;
            [Theta,Rho] = cart2pol(X,Y);
            Theta=Theta+angle/180*pi;
            [X,Y] = pol2cart(Theta,Rho);
            
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+X';
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+Y';
        end
    end
    
    
    %plot all line segments
    if trialID==1
        subplot(1,2,1);
    else
        subplot(1,2,2);
    end
    set(gca,'color','black')
    set(gcf,'color','black')
    
    hold on;
    
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick,'Color',[1*opacity 1*opacity 1*opacity])
        end
    end
    
    hold on
    
    hold off
    
    
    %plot mask, upper and lower part separate
    NumPoints=100;
    Radius=(PatchSizeHalf-2)*BinSize;
    Theta=linspace(0,pi,NumPoints); %100 evenly spaced points between 0 and pi
    Rho=ones(1,NumPoints)*Radius; %Radius should be 1 for all 100 points
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    Theta=linspace(0,-pi,NumPoints); %100 evenly spaced points between 0 and -pi
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=-PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=-PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    hold off
    axis tight; axis square
    view(-Orient/Alpha,90)
    xlim([-Radius*0.8 Radius*0.8])
    ylim([-Radius*0.8 Radius*0.8])
    set(gcf,'MenuBar','none');
    
    
    positionfig=[winx winy winwidth winheight];
    
    
    %positionfig=[1600 50 500 450];
    set(fig1,'OuterPosition',positionfig) ;%move window here, also determines size
    %notusedyet=borderwidth;
else
    
    close(fig1);
    
end

end




function ShowStimulusContourDistractor(trialID, opacity, display, winheight,winwidth,winx,winy,crudetoggle,Orient)


fig1=figure(100);
if display==1
    
    
    diffic = opacity*10;
    opacity = 1;
    
    if crudetoggle==0
        %fine
        
        ContLength=7; % length of contour
        ContLengthHalf=ceil(ContLength/2); %half of the contour
        PatchSize=9; % size of patch, pick uneven
        PatchSizeHalf=floor(PatchSize/2); %half of the patch
        SegmLength=1.2; %length of sements
        BinSize=2; %size of bins
        SegmThick=7; %line thickness9
        SegmJitter= 0.3;% jitter of segments
        
    else
        %crude
        
        ContLength=7; % length of contour
        ContLengthHalf=ceil(ContLength/2); %half of the contour
        PatchSize=11; % size of patch, pick uneven
        PatchSizeHalf=floor(PatchSize/2); %half of the patch
        SegmLength=1.2; %length of sements
        BinSize=2; %size of bins
        SegmThick=9; %line thickness9
        SegmJitter= 0.3;% jitter of segments
        
    end
    
    
    
    
    
    Alpha=-25; %determines closeness of contour elements, set somewhere between [-30 30]
    %see Li & Gilbert 2002
    Alpha=(90+Alpha)/90;
    
    SegmX=zeros(2,PatchSize,PatchSize);
    SegmY=zeros(2,PatchSize,PatchSize);
    % make grid
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=i*BinSize;
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=j*BinSize;
        end
    end
    
    % turn grid around crossing with y-axis
    [SegmTheta,SegmRho] = cart2pol(zeros(2,PatchSize,PatchSize),SegmY);
    SegmTheta(SegmTheta>0)=SegmTheta(SegmTheta>0)/Alpha;
    SegmTheta(SegmTheta<0)=((SegmTheta(SegmTheta<0)+pi)/Alpha)-pi;
    [SegmXA,SegmY] = pol2cart(SegmTheta,SegmRho);
    SegmX=SegmX+SegmXA;
    
    % Draw background with the grid as center
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            angle=rand*180;
            if i==j & i>-ContLengthHalf &i<ContLengthHalf %for contour segments
                angle=45;
                X=[-SegmLength/2 SegmLength/2];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
            else
                JX=SegmJitter*2*(rand-0.5); %introduce jitter on non contour segments only
                JY=SegmJitter*2*(rand-0.5);
                X=[-SegmLength/2 SegmLength/2]+JX;
                Y=[0 0]-JY;
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi;
                [X,Y] = pol2cart(Theta,Rho);
            end
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+X';
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+Y';
        end
    end
    
    
    %plot all line segments
    
    
    
    
    if trialID==1
        figu=subplot(1,2,2);
    else
        subplot(1,2,1);
    end
    
    
    set(gca,'color','black')
    set(gcf,'color','black')
    
    hold on;
    
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            if  floor(rand*10) < diffic
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick,'Color',[1*opacity 1*opacity 1*opacity])
            end
        end
    end
    
    hold on
    
    % Draw segments grid as center
    
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            
            if i==j & i>-ContLengthHalf &i<ContLengthHalf %for contour segments
                angle=45;
                X=[-SegmLength/2 SegmLength/2];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
            end
        end
        
    end
    
    
    
    hold off
    
    
    
    %plot mask, upper and lower part separate
    NumPoints=100;
    Radius=(PatchSizeHalf-2)*BinSize;
    Theta=linspace(0,pi,NumPoints); %100 evenly spaced points between 0 and pi
    Rho=ones(1,NumPoints)*Radius; %Radius should be 1 for all 100 points
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    Theta=linspace(0,-pi,NumPoints); %100 evenly spaced points between 0 and -pi
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=-PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=-PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    
    axis tight; axis square
    
    %
    % if trialID==1
    % view(-Orient/Alpha,90)
    % else
    %     view(-Orient+45/Alpha,90)
    % end
    view(-Orient/Alpha,90)
    
    xlim([-Radius*0.8 Radius*0.8])
    ylim([-Radius*0.8 Radius*0.8])
    
    % print -dbmp LiStim1
    
    
    % SECOND PART OF FOGURE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    hold on
    % make grid
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=i*BinSize;
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=j*BinSize;
        end
    end
    
    % turn grid around crossing with y-axis
    [SegmTheta,SegmRho] = cart2pol(zeros(2,PatchSize,PatchSize),SegmY);
    SegmTheta(SegmTheta>0)=SegmTheta(SegmTheta>0)/Alpha;
    SegmTheta(SegmTheta<0)=((SegmTheta(SegmTheta<0)+pi)/Alpha)-pi;
    [SegmXA,SegmY] = pol2cart(SegmTheta,SegmRho);
    SegmX=SegmX+SegmXA;
    
    % Draw background with the grid as center
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            angle=rand*180;
            
            JX=SegmJitter*2*(rand-0.5); %introduce jitter on non contour segments only
            JY=SegmJitter*2*(rand-0.5);
            X=[-SegmLength/2 SegmLength/2]+JX;
            Y=[0 0]-JY;
            [Theta,Rho] = cart2pol(X,Y);
            Theta=Theta+angle/180*pi;
            [X,Y] = pol2cart(Theta,Rho);
            
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+X';
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+Y';
        end
    end
    
    
    %plot all line segments
    if trialID==1
        subplot(1,2,1);
    else
        subplot(1,2,2);
    end
    set(gca,'color','black')
    set(gcf,'color','black')
    
    hold on;
    
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            if  floor(rand*10) < diffic
                
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick,'Color',[1*opacity 1*opacity 1*opacity])
            end
        end
    end
    
    hold on
    
    
    
    
    
    hold off
    
    
    
    
    %plot mask, upper and lower part separate
    NumPoints=100;
    Radius=(PatchSizeHalf-2)*BinSize;
    Theta=linspace(0,pi,NumPoints); %100 evenly spaced points between 0 and pi
    Rho=ones(1,NumPoints)*Radius; %Radius should be 1 for all 100 points
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    Theta=linspace(0,-pi,NumPoints); %100 evenly spaced points between 0 and -pi
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=-PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=-PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    hold off
    axis tight; axis square
    view(-Orient/Alpha,90)
    xlim([-Radius*0.8 Radius*0.8])
    ylim([-Radius*0.8 Radius*0.8])
    set(gcf,'MenuBar','none');
    
    
    positionfig=[winx winy winwidth winheight];
    
    
    %positionfig=[1600 50 500 450];
    set(fig1,'OuterPosition',positionfig) ;%move window here, also determines size
    %notusedyet=borderwidth;
else
    
    close(fig1);
    
end

end


function ShowStimulusContourTraining(unused, opacity, display, winheight,winwidth,winx,winy,crudetoggle,Orient)


fig1=figure(100);
if display==1
    
    
    
    if crudetoggle==0
        %fine
        
        ContLength=7; % length of contour
        ContLengthHalf=ceil(ContLength/2); %half of the contour
        PatchSize=9; % size of patch, pick uneven
        PatchSizeHalf=floor(PatchSize/2); %half of the patch
        SegmLength=1.2; %length of sements
        BinSize=2; %size of bins
        SegmThick=7; %line thickness9
        SegmJitter= 0.3;% jitter of segments
        
    else
        %crude
        
        ContLength=7; % length of contour
        ContLengthHalf=ceil(ContLength/2); %half of the contour
        PatchSize=11; % size of patch, pick uneven
        PatchSizeHalf=floor(PatchSize/2); %half of the patch
        SegmLength=1.2; %length of sements
        BinSize=2; %size of bins
        SegmThick=9; %line thickness9
        SegmJitter= 0.3;% jitter of segments
        
    end
    
    
    
    
    
    Alpha=-25; %determines closeness of contour elements, set somewhere between [-30 30]
    %see Li & Gilbert 2002
    Alpha=(90+Alpha)/90;
    
    SegmX=zeros(2,PatchSize,PatchSize);
    SegmY=zeros(2,PatchSize,PatchSize);
    % make grid
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=i*BinSize;
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=j*BinSize;
        end
    end
    
    % turn grid around crossing with y-axis
    [SegmTheta,SegmRho] = cart2pol(zeros(2,PatchSize,PatchSize),SegmY);
    SegmTheta(SegmTheta>0)=SegmTheta(SegmTheta>0)/Alpha;
    SegmTheta(SegmTheta<0)=((SegmTheta(SegmTheta<0)+pi)/Alpha)-pi;
    [SegmXA,SegmY] = pol2cart(SegmTheta,SegmRho);
    SegmX=SegmX+SegmXA;
    
    % Draw background with the grid as center
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            angle=rand*180;
            if i==j & i>-ContLengthHalf &i<ContLengthHalf %for contour segments
                angle=45;
                X=[-SegmLength/2 SegmLength/2];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
            else
                JX=SegmJitter*2*(rand-0.5); %introduce jitter on non contour segments only
                JY=SegmJitter*2*(rand-0.5);
                X=[-SegmLength/2 SegmLength/2]+JX;
                Y=[0 0]-JY;
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi;
                [X,Y] = pol2cart(Theta,Rho);
            end
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+X';
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+Y';
        end
    end
    
    
    %plot all line segments
    
    
    %both sides
    for sides = 1:2
        
        if sides == 1
            subplot(1,2,1);
        else
            subplot(1,2,2);
        end
        
        
        set(gca,'color','black')
        set(gcf,'color','black')
        
        hold on;
        
        for i=-PatchSizeHalf:PatchSizeHalf
            for j=-PatchSizeHalf:PatchSizeHalf
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick,'Color',[1*opacity 1*opacity 1*opacity])
            end
        end
        
        hold on
        
        % Draw segments grid as center
        
        for i=-PatchSizeHalf:PatchSizeHalf
            for j=-PatchSizeHalf:PatchSizeHalf
                
                if i==j & i>-ContLengthHalf &i<ContLengthHalf %for contour segments
                    angle=45;
                    X=[-SegmLength/2 SegmLength/2];
                    Y=[0 0];
                    [Theta,Rho] = cart2pol(X,Y);
                    Theta=Theta+angle/180*pi/Alpha;
                    [X,Y] = pol2cart(Theta,Rho);
                    plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
                end
            end
            
        end
        
        
        
        hold off
        
        
        
        %plot mask, upper and lower part separate
        NumPoints=100;
        Radius=(PatchSizeHalf-2)*BinSize;
        Theta=linspace(0,pi,NumPoints); %100 evenly spaced points between 0 and pi
        Rho=ones(1,NumPoints)*Radius; %Radius should be 1 for all 100 points
        [X,Y] = pol2cart(Theta,Rho);
        X(101)=-PatchSize*2;
        Y(101)=0;
        X(102)=-PatchSize*2;
        Y(102)=PatchSize*2;
        X(103)=PatchSize*2;
        Y(103)=PatchSize*2;
        X(104)=PatchSize*2;
        Y(104)=0;
        patch(X,Y,'k');
        Theta=linspace(0,-pi,NumPoints); %100 evenly spaced points between 0 and -pi
        [X,Y] = pol2cart(Theta,Rho);
        X(101)=-PatchSize*2;
        Y(101)=0;
        X(102)=-PatchSize*2;
        Y(102)=-PatchSize*2;
        X(103)=PatchSize*2;
        Y(103)=-PatchSize*2;
        X(104)=PatchSize*2;
        Y(104)=0;
        patch(X,Y,'k');
        
        axis tight; axis square
        
        %
        % if trialID==1
        % view(-Orient/Alpha,90)
        % else
        %     view(-Orient+45/Alpha,90)
        % end
        view(-Orient/Alpha,90)
        
        xlim([-Radius*0.8 Radius*0.8])
        ylim([-Radius*0.8 Radius*0.8])
        
        % print -dbmp LiStim1
    end
    
    
    positionfig=[winx winy winwidth winheight];
    
    
    %positionfig=[1600 50 500 450];
    set(fig1,'OuterPosition',positionfig) ;%move window here, also determines size
    %notusedyet=borderwidth;
else
    
    close(fig1);
    
end

end


function ShowStimulusOnePatchContour(trialID, opacity, display, winheight,winwidth,winx,winy,crudetoggle,Orient)


if crudetoggle==0
    %fine
    
    ContLength=7; % length of contour
    ContLengthHalf=ceil(ContLength/2); %half of the contour
    PatchSize=9; % size of patch, pick uneven
    PatchSizeHalf=floor(PatchSize/2); %half of the patch
    SegmLength=1.2; %length of sements
    BinSize=2; %size of bins
    SegmThick=7; %line thickness9
    SegmJitter= 0.3;% jitter of segments
    
else
    %crude
    
    ContLength=7; % length of contour
    ContLengthHalf=ceil(ContLength/2); %half of the contour
    PatchSize=11; % size of patch, pick uneven
    PatchSizeHalf=floor(PatchSize/2); %half of the patch
    SegmLength=1.2; %length of sements
    BinSize=2; %size of bins
    SegmThick=9; %line thickness9
    SegmJitter= 0.3;% jitter of segments
    
end




fig1=figure(100);

%show yes or no
if display==1
    
    
    
    
    Alpha=-25; %determines closeness of contour elements, set somewhere between [-30 30]
    %see Li & Gilbert 2002
    Alpha=(90+Alpha)/90;
    
    SegmX=zeros(2,PatchSize,PatchSize);
    SegmY=zeros(2,PatchSize,PatchSize);
    
    
    if trialID==1
        
        % make grid
        for i=-PatchSizeHalf:PatchSizeHalf
            for j=-PatchSizeHalf:PatchSizeHalf
                SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=i*BinSize;
                SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=j*BinSize;
            end
        end
        
        % turn grid around crossing with y-axis
        [SegmTheta,SegmRho] = cart2pol(zeros(2,PatchSize,PatchSize),SegmY);
        SegmTheta(SegmTheta>0)=SegmTheta(SegmTheta>0)/Alpha;
        SegmTheta(SegmTheta<0)=((SegmTheta(SegmTheta<0)+pi)/Alpha)-pi;
        [SegmXA,SegmY] = pol2cart(SegmTheta,SegmRho);
        SegmX=SegmX+SegmXA;
        
        % Draw background with the grid as center
        for i=-PatchSizeHalf:PatchSizeHalf
            for j=-PatchSizeHalf:PatchSizeHalf
                angle=rand*180;
                if i==j & i>-ContLengthHalf &i<ContLengthHalf %for contour segments
                    angle=45;
                    X=[-SegmLength/2 SegmLength/2];
                    Y=[0 0];
                    [Theta,Rho] = cart2pol(X,Y);
                    Theta=Theta+angle/180*pi/Alpha;
                    [X,Y] = pol2cart(Theta,Rho);
                else
                    JX=SegmJitter*2*(rand-0.5); %introduce jitter on non contour segments only
                    JY=SegmJitter*2*(rand-0.5);
                    X=[-SegmLength/2 SegmLength/2]+JX;
                    Y=[0 0]-JY;
                    [Theta,Rho] = cart2pol(X,Y);
                    Theta=Theta+angle/180*pi;
                    [X,Y] = pol2cart(Theta,Rho);
                end
                SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+X';
                SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+Y';
            end
        end
        
        
        %plot all line segments
       
        
        set(gca,'color','black')
        set(gcf,'color','black')
        
        hold on;
        
        for i=-PatchSizeHalf:PatchSizeHalf
            for j=-PatchSizeHalf:PatchSizeHalf
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick,'Color',[1*opacity 1*opacity 1*opacity])
            end
        end
        
        hold on
        
        % Draw segments grid as center
        
        for i=-PatchSizeHalf:PatchSizeHalf
            for j=-PatchSizeHalf:PatchSizeHalf
                
                if i==j & i>-ContLengthHalf &i<ContLengthHalf %for contour segments
                    angle=45;
                    X=[-SegmLength/2 SegmLength/2];
                    Y=[0 0];
                    [Theta,Rho] = cart2pol(X,Y);
                    Theta=Theta+angle/180*pi/Alpha;
                    [X,Y] = pol2cart(Theta,Rho);
                    plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
                end
            end
            
        end
        
        
        
        hold off
        
        
        
        %plot mask, upper and lower part separate
        NumPoints=100;
        Radius=(PatchSizeHalf-2)*BinSize;
        Theta=linspace(0,pi,NumPoints); %100 evenly spaced points between 0 and pi
        Rho=ones(1,NumPoints)*Radius; %Radius should be 1 for all 100 points
        [X,Y] = pol2cart(Theta,Rho);
        X(101)=-PatchSize*2;
        Y(101)=0;
        X(102)=-PatchSize*2;
        Y(102)=PatchSize*2;
        X(103)=PatchSize*2;
        Y(103)=PatchSize*2;
        X(104)=PatchSize*2;
        Y(104)=0;
        patch(X,Y,'k');
        Theta=linspace(0,-pi,NumPoints); %100 evenly spaced points between 0 and -pi
        [X,Y] = pol2cart(Theta,Rho);
        X(101)=-PatchSize*2;
        Y(101)=0;
        X(102)=-PatchSize*2;
        Y(102)=-PatchSize*2;
        X(103)=PatchSize*2;
        Y(103)=-PatchSize*2;
        X(104)=PatchSize*2;
        Y(104)=0;
        patch(X,Y,'k');
        
        axis tight; axis square
        
        %
        % if trialID==1
        % view(-Orient/Alpha,90)
        % else
        %     view(-Orient+45/Alpha,90)
        % end
        view(-Orient/Alpha,90)
        
        xlim([-Radius*0.8 Radius*0.8])
        ylim([-Radius*0.8 Radius*0.8])
        
        % print -dbmp LiStim1
        
    else
        
       
        hold on
        % make grid
        for i=-PatchSizeHalf:PatchSizeHalf
            for j=-PatchSizeHalf:PatchSizeHalf
                SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=i*BinSize;
                SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=j*BinSize;
            end
        end
        
        % turn grid around crossing with y-axis
        [SegmTheta,SegmRho] = cart2pol(zeros(2,PatchSize,PatchSize),SegmY);
        SegmTheta(SegmTheta>0)=SegmTheta(SegmTheta>0)/Alpha;
        SegmTheta(SegmTheta<0)=((SegmTheta(SegmTheta<0)+pi)/Alpha)-pi;
        [SegmXA,SegmY] = pol2cart(SegmTheta,SegmRho);
        SegmX=SegmX+SegmXA;
        
        % Draw background with the grid as center
        for i=-PatchSizeHalf:PatchSizeHalf
            for j=-PatchSizeHalf:PatchSizeHalf
                angle=rand*180;
                
                JX=SegmJitter*2*(rand-0.5); %introduce jitter on non contour segments only
                JY=SegmJitter*2*(rand-0.5);
                X=[-SegmLength/2 SegmLength/2]+JX;
                Y=[0 0]-JY;
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi;
                [X,Y] = pol2cart(Theta,Rho);
                
                SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+X';
                SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+Y';
            end
        end
        
        
        %plot all line segments
        
        set(gca,'color','black')
        set(gcf,'color','black')
        
        hold on;
        
        for i=-PatchSizeHalf:PatchSizeHalf
            for j=-PatchSizeHalf:PatchSizeHalf
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick,'Color',[1*opacity 1*opacity 1*opacity])
            end
        end
        
        hold on
        
        
        
        
        
        hold off
        
        
        
        
        %plot mask, upper and lower part separate
        NumPoints=100;
        Radius=(PatchSizeHalf-2)*BinSize;
        Theta=linspace(0,pi,NumPoints); %100 evenly spaced points between 0 and pi
        Rho=ones(1,NumPoints)*Radius; %Radius should be 1 for all 100 points
        [X,Y] = pol2cart(Theta,Rho);
        X(101)=-PatchSize*2;
        Y(101)=0;
        X(102)=-PatchSize*2;
        Y(102)=PatchSize*2;
        X(103)=PatchSize*2;
        Y(103)=PatchSize*2;
        X(104)=PatchSize*2;
        Y(104)=0;
        patch(X,Y,'k');
        Theta=linspace(0,-pi,NumPoints); %100 evenly spaced points between 0 and -pi
        [X,Y] = pol2cart(Theta,Rho);
        X(101)=-PatchSize*2;
        Y(101)=0;
        X(102)=-PatchSize*2;
        Y(102)=-PatchSize*2;
        X(103)=PatchSize*2;
        Y(103)=-PatchSize*2;
        X(104)=PatchSize*2;
        Y(104)=0;
        patch(X,Y,'k');
        hold off
        axis tight; axis square
        view(-Orient+45/Alpha,90)
        xlim([-Radius*0.8 Radius*0.8])
        ylim([-Radius*0.8 Radius*0.8])
        set(gcf,'MenuBar','none');
        
     
        
    end
    
       
        positionfig=[winx winy winwidth winheight];
        %positionfig=[1600 50 500 450];
        set(fig1,'OuterPosition',positionfig) ;%move window here, also determines size
        %notusedyet=borderwidth;
    
else
   
    close(fig1);
    
end

end


%create individual stimulus Circle
function ShowStimulusTwoTaskCircle(trialID, opacity, display, winheight,winwidth,winx,winy,crudetoggle,Orient)


fig1=figure(100);
if display==1
    
    if crudetoggle==0
        %fine
        
        ContLength=7; % length of contour
        ContLengthHalf=ceil(ContLength/2); %half of the contour
        PatchSize=9; % size of patch, pick uneven
        PatchSizeHalf=floor(PatchSize/2); %half of the patch
        SegmLength=1.2; %length of sements
        BinSize=2; %size of bins
        SegmThick=7; %line thickness9
        SegmJitter= 0.3;% jitter of segments
        
    else
        %crude
        
        ContLength=3; % length of contour
        ContLengthHalf=ceil(ContLength/2); %half of the contour
        PatchSize=13; % size of patch, pick uneven
        PatchSizeHalf=floor(PatchSize/2); %half of the patch
        SegmLength=1.2; %length of sements
        BinSize=2; %size of bins
        SegmThick=7; %line thickness9
        SegmJitter= 0.3;% jitter of segments
        
    end
    
    
    
    Alpha=-25; %determines closeness of contour elements, set somewhere between [-30 30]
    %see Li & Gilbert 2002
    Alpha=(90+Alpha)/90;
    
    SegmX=zeros(2,PatchSize,PatchSize);
    SegmY=zeros(2,PatchSize,PatchSize);
    % make grid
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=i*BinSize;
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=j*BinSize;
        end
    end
    
    % turn grid around crossing with y-axis
    [SegmTheta,SegmRho] = cart2pol(zeros(2,PatchSize,PatchSize),SegmY);
    SegmTheta(SegmTheta>0)=SegmTheta(SegmTheta>0)/Alpha;
    SegmTheta(SegmTheta<0)=((SegmTheta(SegmTheta<0)+pi)/Alpha)-pi;
    [SegmXA,SegmY] = pol2cart(SegmTheta,SegmRho);
    SegmX=SegmX+SegmXA;
    
    % Draw CIRCLE
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            angle=rand*180;
            
            if i==j  & i==ContLengthHalf-2 %for contour segments (take center colum and then go along that)
                JX=SegmJitter*2*(rand-0.5); %introduce jitter on non contour segments only
                JY=SegmJitter*2*(rand-0.5);
                
                
                X=[-SegmLength*0.1-0.7 SegmLength*0.9-0.7];
                Y=[-0.5 -0.5];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
                
            elseif i==j  & i>-ContLengthHalf &i<ContLengthHalf & i  %for contour segments (take center colum and then go along that)
                angle=110;
                X=[-SegmLength*0.1-0.7 SegmLength*0.9-0.7];
                Y=[-0.5 -0.5];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
                
                
            elseif  i==j  & i>-ContLengthHalf &i<ContLengthHalf %make sure the center of O is not  rand_array(1,rand_index)omly filling patch (avoid 45)
                
                angle= 155+75;
                X=[-SegmLength*0.1 SegmLength*0.9]+JX-0.17;
                Y=[0 0]-JY-0.4;
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi;
                [X,Y] = pol2cart(Theta,Rho);
                
                
                
                
            elseif i==j-1  & i>-ContLengthHalf &i<ContLengthHalf %for contour segments (take center colum and then go along that)
                if i == - ContLengthHalf+1
                    angle=82;
                    X=[-SegmLength*0.85-0.14 SegmLength*0.15-0.14];
                    Y=[-0.4 -0.4];
                    [Theta,Rho] = cart2pol(X,Y);
                    Theta=Theta+angle/180*pi/Alpha;
                    [X,Y] = pol2cart(Theta,Rho);
                    
                elseif   i == ContLengthHalf-1
                    angle=140;
                    X=[-SegmLength*0.85+0.5 SegmLength*0.15+0.5];
                    Y=[1 1];
                    [Theta,Rho] = cart2pol(X,Y);
                    Theta=Theta+angle/180*pi/Alpha;
                    [X,Y] = pol2cart(Theta,Rho);
                    
                else
                    angle=45;
                    X=[-SegmLength*0.85 SegmLength*0.15];
                    Y=[0 0];
                    [Theta,Rho] = cart2pol(X,Y);
                    Theta=Theta+angle/180*pi/Alpha;
                    [X,Y] = pol2cart(Theta,Rho);
                end
                
            elseif i==j+1  & i>-ContLengthHalf+1 &i<ContLengthHalf+1 %for contour segments (take center colum and then go along that)
                if i ==  -ContLengthHalf+2
                    angle=140;
                    X=[-SegmLength*0.85+0.57 SegmLength*0.15+0.57];
                    Y=[-0.2 -0.2];
                    [Theta,Rho] = cart2pol(X,Y);
                    Theta=Theta+angle/180*pi/Alpha;
                    [X,Y] = pol2cart(Theta,Rho);
                    
                elseif   i == ContLengthHalf-1
                    angle=45;
                    X=[-SegmLength*0.85-0.1 SegmLength*0.15-0.1];
                    Y=[-0.28 -0.28];
                    [Theta,Rho] = cart2pol(X,Y);
                    Theta=Theta+angle/180*pi/Alpha;
                    [X,Y] = pol2cart(Theta,Rho);
                    
                else
                    angle=80;
                    X=[-SegmLength*0.85-0.02 SegmLength*0.15-0.02];
                    Y=[0.9 0.9];
                    [Theta,Rho] = cart2pol(X,Y);
                    Theta=Theta+angle/180*pi/Alpha;
                    [X,Y] = pol2cart(Theta,Rho);
                end
                
            else
                JX=SegmJitter*2*(rand-0.5); %introduce jitter on non contour segments only
                JY=SegmJitter*2*(rand-0.5);
                X=[-SegmLength/2 SegmLength/2]+JX;
                Y=[0 0]-JY;
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi;
                [X,Y] = pol2cart(Theta,Rho);
                
            end
            
            
            
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+X';
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+Y';
        end
    end
    
    
    %plot all line segments
    
    
    
    if trialID==1
        figu=subplot(1,2,2);
    else
        subplot(1,2,1);
    end
    
    
    set(gca,'color','black')
    set(gcf,'color','black')
    
    hold on;
    
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick,'Color',[1*opacity 1*opacity 1*opacity])
        end
    end
    
    hold on
    
    % Draw CIRCLE
    
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            
            
            
            if i==j  & i>-ContLengthHalf &i<ContLengthHalf & i~=ContLengthHalf & i~=0%for contour segments (take center colum and then go along that)
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
                
                
            elseif i==j-1  & i>-ContLengthHalf &i<ContLengthHalf %for contour segments (take center colum and then go along that)
                
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
                
                
            elseif i==j+1  & i>-ContLengthHalf+1 &i<ContLengthHalf+1 %for contour segments (take center colum and then go along that)
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
                
                
            end
            
            
            
            
        end
        
    end
    
    
    
    hold off
    
    
    %plot mask, upper and lower part separate
    NumPoints=100;
    Radius=(PatchSizeHalf-2)*BinSize;
    Theta=linspace(0,pi,NumPoints); %100 evenly spaced points between 0 and pi
    Rho=ones(1,NumPoints)*Radius; %Radius should be 1 for all 100 points
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    Theta=linspace(0,-pi,NumPoints); %100 evenly spaced points between 0 and -pi
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=-PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=-PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    
    axis tight; axis square
    
    %
    % if trialID==1
    % view(-Orient/Alpha,90)
    % else
    %     view(-Orient+45/Alpha,90)
    % end
    view(-Orient/Alpha,90)
    
    xlim([-Radius*0.8 Radius*0.8])
    ylim([-Radius*0.8 Radius*0.8])
    
    % print -dbmp LiStim1
    
    
    % SECOND PART OF FIGURE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    hold on
    % make grid
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=i*BinSize;
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=j*BinSize;
        end
    end
    
    % turn grid around crossing with y-axis
    [SegmTheta,SegmRho] = cart2pol(zeros(2,PatchSize,PatchSize),SegmY);
    SegmTheta(SegmTheta>0)=SegmTheta(SegmTheta>0)/Alpha;
    SegmTheta(SegmTheta<0)=((SegmTheta(SegmTheta<0)+pi)/Alpha)-pi;
    [SegmXA,SegmY] = pol2cart(SegmTheta,SegmRho);
    SegmX=SegmX+SegmXA;
    
    % Draw background with the grid as center
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            angle=rand*180;
            
            
            
            if i==j+2  & i==ContLengthHalf  %for contour segments (take center colum and then go along that)
                angle=1;
                % X=[-(SegmLength*0.4)+SegmLength (SegmLength*0.6)+SegmLength];
                X=[-(SegmLength*0.8) (SegmLength*0.2)];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
                
            elseif i==j+1  & i==ContLengthHalf-1  %for contour segments (take center colum and then go along that)
                angle=1;
                % X=[-(SegmLength*0.4)+SegmLength (SegmLength*0.6)+SegmLength];
                X=[-(SegmLength*0.8) (SegmLength*0.2)];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
                
            elseif i==j  & i==ContLengthHalf-2  %for contour segments (take center colum and then go along that)
                angle=1;
                % X=[-(SegmLength*0.4)+SegmLength (SegmLength*0.6)+SegmLength];
                X=[-(SegmLength*0.8) (SegmLength*0.2)];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
                
            elseif i==j-1  & i==ContLengthHalf-3  %for contour segments (take center colum and then go along that)
                angle=1;
                % X=[-(SegmLength*0.4)+SegmLength (SegmLength*0.6)+SegmLength];
                X=[-(SegmLength*0.8) (SegmLength*0.2)];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
                
            elseif i==j-2  & i==ContLengthHalf-4  %for contour segments (take center colum and then go along that)
                angle=1;
                % X=[-(SegmLength*0.4)+SegmLength (SegmLength*0.6)+SegmLength];
                X=[-(SegmLength*0.8) (SegmLength*0.2)];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
                
                
            elseif i==j-2  & i==ContLengthHalf-2  %for contour segments (take center colum and then go along that)
                angle=90;
                % X=[-(SegmLength*0.4)+SegmLength (SegmLength*0.6)+SegmLength];
                X=[-(SegmLength*0.8) (SegmLength*0.2)];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
                
                
            elseif i==j-1  & i==ContLengthHalf-2  %for contour segments (take center colum and then go along that)
                angle=90;
                % X=[-(SegmLength*0.4)+SegmLength (SegmLength*0.6)+SegmLength];
                X=[-(SegmLength*0.8) (SegmLength*0.2)];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
                
                
            elseif i==j+1  & i==ContLengthHalf-2  %for contour segments (take center colum and then go along that)
                angle=90;
                % X=[-(SegmLength*0.4)+SegmLength (SegmLength*0.6)+SegmLength];
                X=[-(SegmLength*0.1) (SegmLength*0.9)];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
            elseif i==j+2  & i==ContLengthHalf-2  %for contour segments (take center colum and then go along that)
                angle=90;
                % X=[-(SegmLength*0.4)+SegmLength (SegmLength*0.6)+SegmLength];
                X=[-(SegmLength*0.1) (SegmLength*0.9)];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
                
                
                
                
                
            else
                JX=SegmJitter*2*(rand-0.5); %introduce jitter on non contour segments only
                JY=SegmJitter*2*(rand-0.5);
                X=[-SegmLength/2 SegmLength/2]+JX;
                Y=[0 0]-JY;
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi;
                [X,Y] = pol2cart(Theta,Rho);
                
            end
            
            
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+X';
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+Y';
        end
    end
    
    %plot all line segments
    
    if trialID==1
        figu=subplot(1,2,1);
    else
        subplot(1,2,2);
    end
    
    
    set(gca,'color','black')
    set(gcf,'color','black')
    
    hold on;
    
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick,'Color',[1*opacity 1*opacity 1*opacity])
        end
    end
    
    hold on
    
    % Draw segments grid as center
    
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            
            
            if i==j+2  & i==ContLengthHalf  %for contour segments (take center colum and then go along that)
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
                
            elseif i==j+1  & i==ContLengthHalf-1  %for contour segments (take center colum and then go along that)
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
                
            elseif i==j  & i==ContLengthHalf-2  %for contour segments (take center colum and then go along that)
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
                
            elseif i==j-1  & i==ContLengthHalf-3  %for contour segments (take center colum and then go along that)
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
                
            elseif i==j-2  & i==ContLengthHalf-4  %for contour segments (take center colum and then go along that)
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
                
                
            elseif i==j-2  & i==ContLengthHalf-2  %for contour segments (take center colum and then go along that)
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
                
            elseif i==j-1  & i==ContLengthHalf-2  %for contour segments (take center colum and then go along that)
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
                
                
            elseif i==j+1  & i==ContLengthHalf-2  %for contour segments (take center colum and then go along that)
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
                
            elseif i==j+2  & i==ContLengthHalf-2  %for contour segments (take center colum and then go along that)
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
                
                
                
                
                
            end
        end
        
    end
    
    
    hold off
    
    
    
    
    
    
    %plot mask, upper and lower part separate
    NumPoints=100;
    Radius=(PatchSizeHalf-2)*BinSize;
    Theta=linspace(0,pi,NumPoints); %100 evenly spaced points between 0 and pi
    Rho=ones(1,NumPoints)*Radius; %Radius should be 1 for all 100 points
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    Theta=linspace(0,-pi,NumPoints); %100 evenly spaced points between 0 and -pi
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=-PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=-PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    
    axis tight; axis square
    
    view(-Orient/Alpha,90)
    
    xlim([-Radius*0.8 Radius*0.8])
    ylim([-Radius*0.8 Radius*0.8])
    set(gcf,'MenuBar','none');
    
    
    positionfig=[winx winy winwidth winheight];
    %positionfig=[1600 50 500 450];
    set(fig1,'OuterPosition',positionfig) ;%move window here, also determines size
    %notusedyet=borderwidth;
else
    
    close(fig1);
    
end


end

%create individual stimulus Circle
function ShowStimulusTwoTaskCircleCUE(trialID, opacity, display, winheight,winwidth,winx,winy,crudetoggle,Orient)

fig1=figure(100);
opacity = 0;
color = 'w';
if display==1
    
    if crudetoggle==0
        %fine
        
        ContLength=7; % length of contour
        ContLengthHalf=ceil(ContLength/2); %half of the contour
        PatchSize=9; % size of patch, pick uneven
        PatchSizeHalf=floor(PatchSize/2); %half of the patch
        SegmLength=1.2; %length of sements
        BinSize=2; %size of bins
        SegmThick=7; %line thickness9
        SegmJitter= 0.3;% jitter of segments
        
    else
        %crude
        
        ContLength=3; % length of contour
        ContLengthHalf=ceil(ContLength/2); %half of the contour
        PatchSize=13; % size of patch, pick uneven
        PatchSizeHalf=floor(PatchSize/2); %half of the patch
        SegmLength=1.2; %length of sements
        BinSize=2; %size of bins
        SegmThick=7; %line thickness9
        SegmJitter= 0.3;% jitter of segments
        
    end
    
    
    Alpha=-25; %determines closeness of contour elements, set somewhere between [-30 30]
    %see Li & Gilbert 2002
    Alpha=(90+Alpha)/90;
    
    SegmX=zeros(2,PatchSize,PatchSize);
    SegmY=zeros(2,PatchSize,PatchSize);
    % make grid
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=i*BinSize;
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=j*BinSize;
        end
    end
    
    % turn grid around crossing with y-axis
    [SegmTheta,SegmRho] = cart2pol(zeros(2,PatchSize,PatchSize),SegmY);
    SegmTheta(SegmTheta>0)=SegmTheta(SegmTheta>0)/Alpha;
    SegmTheta(SegmTheta<0)=((SegmTheta(SegmTheta<0)+pi)/Alpha)-pi;
    [SegmXA,SegmY] = pol2cart(SegmTheta,SegmRho);
    SegmX=SegmX+SegmXA;
    
    
    % Draw background with the grid as center
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            angle=rand*180;
            if i==j  & i>-ContLengthHalf &i<ContLengthHalf & i  %for contour segments (take center colum and then go along that)
                angle=110;
                X=[-SegmLength*0.1-0.7 SegmLength*0.9-0.7];
                Y=[-0.5 -0.5];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
                
                
            elseif  i==j  & i>-ContLengthHalf &i<ContLengthHalf %make sure the center of O is not  rand_array(1,rand_index)omly filling patch (avoid 45)
                
                JX=SegmJitter*2*(rand-0.5); %introduce jitter on non contour segments only
                JY=SegmJitter*2*(rand-0.5);
                X=[-SegmLength*0.1 SegmLength*0.9]+JX-0.17;
                Y=[0 0]-JY-0.4;
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi;
                [X,Y] = pol2cart(Theta,Rho);
                
                
                
                
            elseif i==j-1  & i>-ContLengthHalf &i<ContLengthHalf %for contour segments (take center colum and then go along that)
                if i == - ContLengthHalf+1
                    angle=82;
                    X=[-SegmLength*0.85-0.14 SegmLength*0.15-0.14];
                    Y=[-0.4 -0.4];
                    [Theta,Rho] = cart2pol(X,Y);
                    Theta=Theta+angle/180*pi/Alpha;
                    [X,Y] = pol2cart(Theta,Rho);
                    
                elseif   i == ContLengthHalf-1
                    angle=140;
                    X=[-SegmLength*0.85+0.5 SegmLength*0.15+0.5];
                    Y=[1 1];
                    [Theta,Rho] = cart2pol(X,Y);
                    Theta=Theta+angle/180*pi/Alpha;
                    [X,Y] = pol2cart(Theta,Rho);
                    
                else
                    angle=45;
                    X=[-SegmLength*0.85 SegmLength*0.15];
                    Y=[0 0];
                    [Theta,Rho] = cart2pol(X,Y);
                    Theta=Theta+angle/180*pi/Alpha;
                    [X,Y] = pol2cart(Theta,Rho);
                end
                
            elseif i==j+1  & i>-ContLengthHalf+1 &i<ContLengthHalf+1 %for contour segments (take center colum and then go along that)
                if i ==  -ContLengthHalf+2
                    angle=140;
                    X=[-SegmLength*0.85+0.57 SegmLength*0.15+0.57];
                    Y=[-0.2 -0.2];
                    [Theta,Rho] = cart2pol(X,Y);
                    Theta=Theta+angle/180*pi/Alpha;
                    [X,Y] = pol2cart(Theta,Rho);
                    
                elseif   i == ContLengthHalf-1
                    angle=45;
                    X=[-SegmLength*0.85-0.1 SegmLength*0.15-0.1];
                    Y=[-0.28 -0.28];
                    [Theta,Rho] = cart2pol(X,Y);
                    Theta=Theta+angle/180*pi/Alpha;
                    [X,Y] = pol2cart(Theta,Rho);
                    
                else
                    angle=80;
                    X=[-SegmLength*0.85-0.02 SegmLength*0.15-0.02];
                    Y=[0.9 0.9];
                    [Theta,Rho] = cart2pol(X,Y);
                    Theta=Theta+angle/180*pi/Alpha;
                    [X,Y] = pol2cart(Theta,Rho);
                end
                
            else
                JX=SegmJitter*2*(rand-0.5); %introduce jitter on non contour segments only
                JY=SegmJitter*2*(rand-0.5);
                X=[-SegmLength/2 SegmLength/2]+JX;
                Y=[0 0]-JY;
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi;
                [X,Y] = pol2cart(Theta,Rho);
                
            end
            
            
            
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+X';
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+Y';
        end
    end
    
    
    %plot all line segments
    
    
    
    
    set(gca,'color','black')
    set(gcf,'color','black')
    
    hold on;
    
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick,'Color',[1*opacity 1*opacity 1*opacity])
        end
    end
    
    hold on
    
    % Draw segments grid as center
    
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            
            
            
            if i==j  & i>-ContLengthHalf &i<ContLengthHalf & i~=ContLengthHalf & i~=0%for contour segments (take center colum and then go along that)
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),color,'LineWidth',SegmThick)
                
                
            elseif i==j-1  & i>-ContLengthHalf &i<ContLengthHalf %for contour segments (take center colum and then go along that)
                
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),color,'LineWidth',SegmThick)
                
                
            elseif i==j+1  & i>-ContLengthHalf+1 &i<ContLengthHalf+1 %for contour segments (take center colum and then go along that)
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),color,'LineWidth',SegmThick)
                
                
            end
            
            
            
            
        end
        
    end
    
    
    
    hold off
    
    
    %plot mask, upper and lower part separate
    NumPoints=100;
    Radius=(PatchSizeHalf-2)*BinSize;
    Theta=linspace(0,pi,NumPoints); %100 evenly spaced points between 0 and pi
    Rho=ones(1,NumPoints)*Radius; %Radius should be 1 for all 100 points
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    Theta=linspace(0,-pi,NumPoints); %100 evenly spaced points between 0 and -pi
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=-PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=-PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    
    axis tight; axis square
    
    view(-Orient/Alpha,90)
    
    xlim([-Radius*0.8 Radius*0.8])
    ylim([-Radius*0.8 Radius*0.8])
    set(gcf,'MenuBar','none');
    
    
    positionfig=[winx winy winwidth winheight];
    %positionfig=[1600 50 500 450];
    set(fig1,'OuterPosition',positionfig) ;%move window here, also determines size
    %notusedyet=borderwidth;
else
    
    close(fig1);
    
end


end

%create individual stimulus Circle
function ShowStimulusTwoTaskContour(trialID, opacity, display, winheight,winwidth,winx,winy,crudetoggle,Orient)


fig1=figure(100);
if display==1
    
    if crudetoggle==0
        %fine
        
        ContLength=7; % length of contour
        ContLengthHalf=ceil(ContLength/2); %half of the contour
        PatchSize=9; % size of patch, pick uneven
        PatchSizeHalf=floor(PatchSize/2); %half of the patch
        SegmLength=1.2; %length of sements
        BinSize=2; %size of bins
        SegmThick=7; %line thickness9
        SegmJitter= 0.3;% jitter of segments
        
    else
        %crude
        
        ContLength=7; % length of contour
        ContLengthHalf=ceil(ContLength/2); %half of the contour
        PatchSize=13; % size of patch, pick uneven
        PatchSizeHalf=floor(PatchSize/2); %half of the patch
        SegmLength=1.2; %length of sements
        BinSize=2; %size of bins
        SegmThick=7; %line thickness9
        SegmJitter= 0.3;% jitter of segments
        
    end
    
    
    Alpha=-25; %determines closeness of contour elements, set somewhere between [-30 30]
    %see Li & Gilbert 2002
    Alpha=(90+Alpha)/90;
    
    SegmX=zeros(2,PatchSize,PatchSize);
    SegmY=zeros(2,PatchSize,PatchSize);
    % make grid
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=i*BinSize;
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=j*BinSize;
        end
    end
    
    % turn grid around crossing with y-axis
    [SegmTheta,SegmRho] = cart2pol(zeros(2,PatchSize,PatchSize),SegmY);
    SegmTheta(SegmTheta>0)=SegmTheta(SegmTheta>0)/Alpha;
    SegmTheta(SegmTheta<0)=((SegmTheta(SegmTheta<0)+pi)/Alpha)-pi;
    [SegmXA,SegmY] = pol2cart(SegmTheta,SegmRho);
    SegmX=SegmX+SegmXA;
    
    % Draw background with the grid as center
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            angle=rand*180;
            if i==j & i>-ContLengthHalf &i<ContLengthHalf %for contour segments
                angle=45;
                X=[-SegmLength/2 SegmLength/2];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
            else
                JX=SegmJitter*2*(rand-0.5); %introduce jitter on non contour segments only
                JY=SegmJitter*2*(rand-0.5);
                X=[-SegmLength/2 SegmLength/2]+JX;
                Y=[0 0]-JY;
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi;
                [X,Y] = pol2cart(Theta,Rho);
            end
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+X';
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+Y';
        end
    end
    
    
    %plot all line segments
    
    
    
    
    if trialID==1
        figu=subplot(1,2,2);
    else
        subplot(1,2,1);
    end
    
    
    set(gca,'color','black')
    set(gcf,'color','black')
    
    hold on;
    
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick,'Color',[1*opacity 1*opacity 1*opacity])
        end
    end
    
    hold on
    
    % Draw CONTOUR grid as center
    
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            
            if i==j & i>-ContLengthHalf &i<ContLengthHalf %for contour segments
                angle=45;
                X=[-SegmLength/2 SegmLength/2];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
            end
        end
        
    end
    
    
    hold off
    
    
    %plot mask, upper and lower part separate
    NumPoints=100;
    Radius=(PatchSizeHalf-2)*BinSize;
    Theta=linspace(0,pi,NumPoints); %100 evenly spaced points between 0 and pi
    Rho=ones(1,NumPoints)*Radius; %Radius should be 1 for all 100 points
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    Theta=linspace(0,-pi,NumPoints); %100 evenly spaced points between 0 and -pi
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=-PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=-PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    
    axis tight; axis square
    
    
    view(-Orient/Alpha,90)
    
    xlim([-Radius*0.8 Radius*0.8])
    ylim([-Radius*0.8 Radius*0.8])
    
    
    
    
    % SECOND PART OF FIGURE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    hold on
    % make grid
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=i*BinSize;
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=j*BinSize;
        end
    end
    
    % turn grid around crossing with y-axis
    [SegmTheta,SegmRho] = cart2pol(zeros(2,PatchSize,PatchSize),SegmY);
    SegmTheta(SegmTheta>0)=SegmTheta(SegmTheta>0)/Alpha;
    SegmTheta(SegmTheta<0)=((SegmTheta(SegmTheta<0)+pi)/Alpha)-pi;
    [SegmXA,SegmY] = pol2cart(SegmTheta,SegmRho);
    SegmX=SegmX+SegmXA;
    
    % Draw background with the grid as center
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            angle=rand*180;
            
            if i==j  & i>ContLengthHalf-1 &i<ContLengthHalf-3  %for contour segments (take center colum and then go along that)
                angle=45;
                X=[-SegmLength*0.1 SegmLength*0.9];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
                
            elseif i==j-1  & i>ContLengthHalf-6 &i<ContLengthHalf-2%for contour segments (take center colum and then go along that)
                angle=45;
                X=[-SegmLength*0.85 SegmLength*0.15];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
                
                
                
            elseif i==j+1  & i>ContLengthHalf-5 &i<ContLengthHalf-1 %for contour segments (take center colum and then go along that)
                angle=45;
                % X=[-(SegmLength*0.4)+SegmLength (SegmLength*0.6)+SegmLength];
                X=[-(SegmLength*0.8) (SegmLength*0.2)];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
                
            else
                JX=SegmJitter*2*(rand-0.5); %introduce jitter on non contour segments only
                JY=SegmJitter*2*(rand-0.5);
                X=[-SegmLength/2 SegmLength/2]+JX;
                Y=[0 0]-JY;
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi;
                [X,Y] = pol2cart(Theta,Rho);
                
            end
            
            
            
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+X';
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+Y';
        end
    end
    
    
    %plot all line segments
    
    
    
    if trialID==1
        figu=subplot(1,2,1);
    else
        subplot(1,2,2);
    end
    
    
    set(gca,'color','black')
    set(gcf,'color','black')
    
    hold on;
    
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick,'Color',[1*opacity 1*opacity 1*opacity])
        end
    end
    
    hold on
    
    % Draw segments grid as center
    
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            
            
            
            
            
            
            if i==j  & i>ContLengthHalf-1 &i<ContLengthHalf-3  %for contour segments (take center colum and then go along that)
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
                
                
            elseif i==j-1  & i>ContLengthHalf-6 &i<ContLengthHalf-2%for contour segments (take center colum and then go along that)
                
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
                
                
            elseif i==j+1  & i>ContLengthHalf-5 &i<ContLengthHalf-1 %for contour segments (take center colum and then go along that)
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick)
                
                
            end
            
            
            
            
        end
        
    end
    
    
    
    hold off
    
    
    
    %plot mask, upper and lower part separate
    NumPoints=100;
    Radius=(PatchSizeHalf-2)*BinSize;
    Theta=linspace(0,pi,NumPoints); %100 evenly spaced points between 0 and pi
    Rho=ones(1,NumPoints)*Radius; %Radius should be 1 for all 100 points
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    Theta=linspace(0,-pi,NumPoints); %100 evenly spaced points between 0 and -pi
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=-PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=-PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    
    axis tight; axis square
    
    %
    % if trialID==1
    % view(-Orient/Alpha,90)
    % else
    %     view(-Orient+45/Alpha,90)
    % end
    view(-Orient/Alpha,90)
    
    xlim([-Radius*0.8 Radius*0.8])
    ylim([-Radius*0.8 Radius*0.8])
    
    pause(0.01);
    
    positionfig=[winx winy winwidth winheight];
    
    set(fig1,'OuterPosition',positionfig) ;%move window here, also determines size
else
    
    close(fig1);
    
end


end

%create individual stimulus Circle
function ShowStimulusTwoTaskContourCUE(trialID, opacity, display, winheight,winwidth,winx,winy,crudetoggle,Orient)

fig1=figure(100);
opacity = 0;
color = 'w';
if display==1
    
    if crudetoggle==0
        %fine
        
        ContLength=7; % length of contour
        ContLengthHalf=ceil(ContLength/2); %half of the contour
        PatchSize=9; % size of patch, pick uneven
        PatchSizeHalf=floor(PatchSize/2); %half of the patch
        SegmLength=1.2; %length of sements
        BinSize=2; %size of bins
        SegmThick=7; %line thickness9
        SegmJitter= 0.3;% jitter of segments
        
    else
        %crude
        
        ContLength=7; % length of contour
        ContLengthHalf=ceil(ContLength/2); %half of the contour
        PatchSize=13; % size of patch, pick uneven
        PatchSizeHalf=floor(PatchSize/2); %half of the patch
        SegmLength=1.2; %length of sements
        BinSize=2; %size of bins
        SegmThick=7; %line thickness9
        SegmJitter= 0.3;% jitter of segments
        
    end
    
    
    Alpha=-25; %determines closeness of contour elements, set somewhere between [-30 30]
    %see Li & Gilbert 2002
    Alpha=(90+Alpha)/90;
    
    SegmX=zeros(2,PatchSize,PatchSize);
    SegmY=zeros(2,PatchSize,PatchSize);
    % make grid
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=i*BinSize;
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=j*BinSize;
        end
    end
    
    % turn grid around crossing with y-axis
    [SegmTheta,SegmRho] = cart2pol(zeros(2,PatchSize,PatchSize),SegmY);
    SegmTheta(SegmTheta>0)=SegmTheta(SegmTheta>0)/Alpha;
    SegmTheta(SegmTheta<0)=((SegmTheta(SegmTheta<0)+pi)/Alpha)-pi;
    [SegmXA,SegmY] = pol2cart(SegmTheta,SegmRho);
    SegmX=SegmX+SegmXA;
    
    % Draw background with the grid as center
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            angle=rand*180;
            if i==j & i>-ContLengthHalf &i<ContLengthHalf %for contour segments
                angle=45;
                X=[-SegmLength/2 SegmLength/2];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
            else
                JX=SegmJitter*2*(rand-0.5); %introduce jitter on non contour segments only
                JY=SegmJitter*2*(rand-0.5);
                X=[-SegmLength/2 SegmLength/2]+JX;
                Y=[0 0]-JY;
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi;
                [X,Y] = pol2cart(Theta,Rho);
            end
            SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+X';
            SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)=SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1)+Y';
        end
    end
    
    
    %plot all line segments
    
    
    
    
    
    set(gca,'color','black')
    set(gcf,'color','black')
    
    hold on;
    
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),'w','LineWidth',SegmThick,'Color',[1*opacity 1*opacity 1*opacity])
        end
    end
    
    hold on
    
    % Draw segments grid as center
    
    for i=-PatchSizeHalf:PatchSizeHalf
        for j=-PatchSizeHalf:PatchSizeHalf
            
            if i==j & i>-ContLengthHalf &i<ContLengthHalf %for contour segments
                angle=45;
                X=[-SegmLength/2 SegmLength/2];
                Y=[0 0];
                [Theta,Rho] = cart2pol(X,Y);
                Theta=Theta+angle/180*pi/Alpha;
                [X,Y] = pol2cart(Theta,Rho);
                plot(SegmX(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),SegmY(:,i+PatchSizeHalf+1,j+PatchSizeHalf+1),color,'LineWidth',SegmThick)
            end
        end
        
    end
    
    
    hold off
    
    
    %plot mask, upper and lower part separate
    NumPoints=100;
    Radius=(PatchSizeHalf-2)*BinSize;
    Theta=linspace(0,pi,NumPoints); %100 evenly spaced points between 0 and pi
    Rho=ones(1,NumPoints)*Radius; %Radius should be 1 for all 100 points
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    Theta=linspace(0,-pi,NumPoints); %100 evenly spaced points between 0 and -pi
    [X,Y] = pol2cart(Theta,Rho);
    X(101)=-PatchSize*2;
    Y(101)=0;
    X(102)=-PatchSize*2;
    Y(102)=-PatchSize*2;
    X(103)=PatchSize*2;
    Y(103)=-PatchSize*2;
    X(104)=PatchSize*2;
    Y(104)=0;
    patch(X,Y,'k');
    axis tight; axis square
    
    view(-Orient/Alpha,90)
    
    xlim([-Radius*0.8 Radius*0.8])
    ylim([-Radius*0.8 Radius*0.8])
    set(gcf,'MenuBar','none');
    
    
    positionfig=[winx winy winwidth winheight];
    %positionfig=[1600 50 500 450];
    set(fig1,'OuterPosition',positionfig) ;%move window here, also determines size
    %notusedyet=borderwidth;
else
    
    close(fig1);
    
end


end



function ShowStimulusGrating(trialID, opacity, display, winheight,winwidth,winx,winy,crudetoggle,Orient)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


fig1=figure(100);
if opacity == 1
    opacity = 0.98;
end
%orientation
 if trialID==1
        %imshowpair(grating0, grating2, 'montage')
         thet=Orient;
         thet2=Orient + 90 - (90* opacity) +0.5;
         if thet == thet2
           thet2 = thet - 0.5; 
         end
 else
        thet=Orient-90;
         thet2=Orient + 90 - (90* opacity) +0.5;
         if thet == thet2
           thet2 = thet - 0.5; 
         end
        %imshowpair(grating2, grating0, 'montage')
        
 end
    
 
%show yes or no
if display==1
    
    if crudetoggle==0
        
        %fine
        %size of bars
        lamd=70;
        
       %offset of bars
        phas=0.25;
        %contrast
        contras=1-opacity;
        phaseRad = 0;
        %for garbor patch
        sigm=10;
        trim=0.005;
        
        %patch size
        percentOfScreenSide = 0.3;
        useMask = 1;
        
    else
        
        %crude
        %size of bars
        lamd=100;
       
        %offset of bars
        phas=0.25;
        %contrast
        contras=1-opacity;
        phaseRad = 0;
        %for garbor patch
        sigm=10;
        trim=0.005;
        %patch size
        percentOfScreenSide = 0.2;
        useMask = 1;
        
    end
    
    
    %PART 1
   
    
    
    X = 1:winwidth;                           % X is a vector from 1 to size
    X0 = (X / winwidth) - .5;                 % rescale X -> -.5 to .5
    freq = winwidth/lamd;                    % compute frequency from wavelength
    [Xm Ym] = meshgrid(X0, X0);             % 2D matrices
    Xf = (Xm * freq * 2*pi);
    thetaRad = ((thet / 360) * 2*pi);        % convert theta (orientation) to radians
    Xt = Xm * cos(thetaRad);                % compute proportion of Xm for given orientation
    Yt = Ym * sin(thetaRad);                % compute proportion of Ym for given orientation
    XYt = [ Xt + Yt ];                      % sum vis.X and Y components
    %these are the stimulus parameters used to display and saved for each
    %object
    grating = sin( Xf + phaseRad);          % make 2D sinewave
    phaseRad = (phas * 2* pi);             % convert to radians: 0 -> 2*pi
    XYf = XYt * freq * 2*pi;                % convert to radians and scale by frequency
    
    
    tempFreUse=freq./2.5;
    
    %the actual grating
    grating = (sin( (XYf+tempFreUse) + phaseRad))*contras;
    %reshape to fit height
    %grating2 = grating(1:end-winwidth-winheight,:);
    
    if winheight>winwidth
        grating= grating(1:winwidth,:);
    else
        grating= grating(1:winheight,:);
    end
    
  
    %patch
    centerCirclex = floor(winwidth*percentOfScreenSide+winheight*percentOfScreenSide*3);
    centerCircley =  floor(winheight*percentOfScreenSide+winheight*percentOfScreenSide*1.5);
    radius  = floor((winheight)*(percentOfScreenSide*2));
    mask = bsxfun(@plus, ((1:winwidth) - centerCirclex).^2, (transpose(1:winheight) -  centerCircley).^2) < radius^2;
    
    
    
    
    
    
    if useMask == 1
        C=zeros(size(grating));
        C(mask==1)=grating(mask==1);
        grating0 = C;
        
        
    else
        grating0 =  grating;
    end
    
    
    
    
    
    
    %PART 2
   
    
    
    X = 1:winwidth;                           % X is a vector from 1 to size
    X0 = (X / winwidth) - .5;                 % rescale X -> -.5 to .5
    freq = winwidth/lamd;                    % compute frequency from wavelength
    [Xm Ym] = meshgrid(X0, X0);             % 2D matrices
    Xf = (Xm * freq * 2*pi);
    thetaRad = ((thet2 / 360) * 2*pi);        % convert theta (orientation) to radians
    Xt = Xm * cos(thetaRad);                % compute proportion of Xm for given orientation
    Yt = Ym * sin(thetaRad);                % compute proportion of Ym for given orientation
    XYt = [ Xt + Yt ];                      % sum vis.X and Y components
    %these are the stimulus parameters used to display and saved for each
    %object
    grating = sin( Xf + phaseRad);          % make 2D sinewave
    phaseRad = (phas * 2* pi);             % convert to radians: 0 -> 2*pi
    XYf = XYt * freq * 2*pi;                % convert to radians and scale by frequency
    
    
    tempFreUse=freq./2.5;
    
    %the actual grating
    grating = (sin( (XYf+tempFreUse) + phaseRad))*contras;
    %reshape to fit height
    %grating2 = grating(1:end-winwidth-winheight,:);
    
    if winheight>winwidth
        grating2= grating(1:winwidth,:);
    else
        grating2= grating(1:winheight,:);
    end
    
    %set window prameters
    set(gca,'pos', [0 0 1 1]);               % remove borders from plot
    %set(gcf, 'menu', 'none', 'Color',[.5 .5 .5]); % without background
    colormap gray(256);                     % use gray colormap (0: black, 1: white)
    axis off; axis image;    % use gray colormap
    
    %positionfig=[1600 50 500 450];
    positionfig=[winx winy winwidth winheight];
    %set(fig1,'OuterPosition',positionfig) ;%move window here, also determines size
    
    
    %patch
    centerCirclex = floor(winwidth*percentOfScreenSide+winheight*percentOfScreenSide*3);
    centerCircley =  floor(winheight*percentOfScreenSide+winheight*percentOfScreenSide*1.5);
    radius  = floor((winheight)*(percentOfScreenSide*2));
    mask = bsxfun(@plus, ((1:winwidth) - centerCirclex).^2, (transpose(1:winheight) -  centerCircley).^2) < radius^2;
    
    
    
    
    if useMask == 1
        C=zeros(size(grating2));
        C(mask==1)=grating2(mask==1);
        grating2 = C;
        
        
    end
    
    
    
    
   
    
    
    positionfig=[winx winy winwidth winheight];
    set(fig1,'OuterPosition',positionfig) ;%move window here, also determines size
    
    
    imshowpair(grating2, grating0, 'montage')
    
    
    %imshow(mask);
else
    
    %hide window
    close(fig1);
    
    
end
end
