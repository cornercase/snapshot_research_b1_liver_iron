




%% Rewrite:  24 March 2013
%% Eamon Doyle, CHLA/USC
%% unit test part 1 to confirm that Bloch simulation matches original simulation 
%%
%% 28 September  2007
%% Nilesh Ghugre, CHLA/USC
%% Batch script for simulation

[~,hostname] = system('hostname');
%hostname = strcat(hostname);  %hack to turn hostname from char array into a string.  yuck
hostname = cellstr(hostname); hostname = hostname{1};

%% output directory
% patientDir = '/Users/nilesh/Monte Carlo/DCT-Oct2006/G5 initial simsP 3 Results/Patients3 FE Hep 20um NN GRP-10000 M9P2 WDR-4.1/ProtonDependence'

experimentName = mfilename;  %only used for naming the saved data
codeSubPath = ['ProtonSim' filesep '\simsPBloch'];

if strcmp('tinkertoy',hostname);
    resultsDir = '~/Documents/1Tfields';  %this is actually only where the mag fields are stored
    codeRoot = '/home/eamon/repos/ironbloch/';
    FileDependenciesString = strcat(codeRoot,codeSubPath);
    resultsSaveLoc = '~/Documents/';
        
elseif strcmp(hostname,'terrapinstation');      %% for TerrapinStation
    resultsDir = '~/Documents/1Tfields';  %this is actually only where the mag fields are stored
    codeRoot = '/home/eamon/repos/ironbloch/';
    FileDependenciesString = strcat(codeRoot,codeSubPath);
    resultsSaveLoc = '~/Documents/';

elseif strfind(hostname,'fastecho');      %% for TerrapinStation
    resultsDir = '~/Documents/1Tfields';  %this is actually only
                                          %where the mag fields are
                                          %stored
%    resultsDir = '/auto/rcf-proj/jw3/eamondoy/1Tfields'
    codeRoot = '/home/eamon/repos/ironbloch/';
    FileDependenciesString = strcat(codeRoot,codeSubPath);
    resultsSaveLoc = '~/Documents/';
    
elseif strfind(hostname,'hpc-login2');
    resultsDir = '/auto/rcf-proj/jw3/eamondoy/1Tfields';
    codeRoot = '/auto/rcf-proj/jw3/eamondoy/research_code/';
    FileDependenciesString = strcat(codeRoot,codeSubPath);
    resultsSaveLoc = '/auto/rcf-proj/jw3/eamondoy/results';

elseif (strfind(hostname,'franz'))%||strfind(hostname,'hans'));
    resultsDir = '~/Documents/1Tfields';  %this is actually only where the mag fields are stored
    codeRoot = '/server/home/eamon/Documents/research_code/';
    FileDependenciesString = strcat(codeRoot,codeSubPath);
    resultsSaveLoc = '~/Documents/';

elseif (strfind(hostname,'tinkertoy'));
    resultsDir = '~/Documents/1Tfields';  %this is actually only where the mag fields are stored
    codeRoot = '/home/eamon/repos/ironbloch/';
    FileDependenciesString = strcat(codeRoot,codeSubPath);
    resultsSaveLoc = '~/Documents/';

elseif (strfind(hostname,'SAM'))
    resultsDir = 'C:\Users\Sam Thornton\Desktop\Iron\3Tfields';  %this is actually only where the mag fields are stored
    codeRoot = 'C:\Users\Sam Thornton\Desktop\Iron\ironbloch\ProtonSim';
    FileDependenciesString = strcat(codeRoot,codeSubPath);
    resultsSaveLoc = 'C:\Users\Sam Thornton\Desktop';

else
    %%SAM - follow the convention I have set forth in this file.  DO NOT
    %%PUT YOUR PATHS IN THIS ELSE STATEMENT
    disp('Missing file paths for this server.  Please fix');
    break;
end

tempFileName = sprintf('%s/%s_%s_temp_round3.mat',resultsSaveLoc,experimentName,hostname);


%jDesktop = com.mathworks.mde.desk.MLDesktop.getInstance;
%jDesktop.getMainFrame.setTitle(experimentName);

%%%%%%%%%%%%%%%%%%%%% Nominal parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Field will be generated and saved with these parameters
%% Alterations can be done during proton simulation since they are only
%% multiplying factors.

wetToDryWtRatio = 4.1;  %% WDR, from Zuyderhoudt et al.
%% previous simulations were performed at 3.5, unless specified.

%% To get the iron concentration, keeping approximately the same multiplying 
%% factor as the patients for similar R2 range, (FE*delX/volFrac).
delX = 9.74e-8;       %% 4:1 hemosiderin/ferritin mix


%% All fields will be generated for 1T, appropriate field multipliers will
%% be used during MRI sim below.
B0 = 1.5;     

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%% Parameters that can be altered for geometry generation

cellBiasFlag = 4;   %% 0 for uniform,
%% 1 for inter-cellular gaussian bias,
%% 2 for inter-cellular patient specific anisotropy,
%% 3 for patient specific inter-cellular anisotropy
%% along with inter-particle distance measures.
%% 4, same as 3 but with sinusoids.
%% 5, same as 4 but here only sinusoids are filled, when spheres cannot be
%% accommodated, they are spilled into the hepatocyes. (simulating Type 4
%% hemochromatosis).

if cellBiasFlag == 0
    cellSigma = [];     %% specified but not used !
elseif cellBiasFlag == 1
    cellSigma = 10;     %% std dev of cell-iron pdf
elseif cellBiasFlag == 2
    cellSigma = [];     %% specified but not used !
elseif cellBiasFlag == 3
    cellSigma = [];     %% specified but not used !
elseif cellBiasFlag == 4
    cellSigma = [];     %% specified but not used !    
elseif cellBiasFlag == 5
    cellSigma = [];     %% specified but not used !        
end


%% Dont change for now...
NNfactor = 1;   %% nearest neighbor conversion factor, distance = NNfactor* (from NN histogram)
NNfactorS = 1;    %% sinusoids


%% Distribution Variability Type

distributionVariabilityType = 1;
%% 3, 4, 5, 6 are available but are not going to be used.

%% Variability is std. dev or RMS error
switch distributionVariabilityType

    case 1
        %% 1 : Mean distribution parameters
        Size_Spread_FE_Variability = 0;
        Anisotropy_Spread_FE_Variability = 0;
        Anisotropy_Shape_FE_Variability = 0;
        NN_Shape_FE_Variability = 0;

        
    case 2
        %% 2 : Random
        Size_Spread_FE_Variability = 0.013;      %% stdev
        Anisotropy_Spread_FE_Variability = 0.064;
        Anisotropy_Shape_FE_Variability = 0.412;
        NN_Shape_FE_Variability = 1.221;
        

    case 3
        %% 3 : Object Size Variability, Spread
        Size_Spread_FE_Variability = 0.013;      %% multiples of stdev = 0.012896
        Anisotropy_Spread_FE_Variability = 0;
        Anisotropy_Shape_FE_Variability = 0;
        NN_Shape_FE_Variability = 0;


    case 4
        %% 4 : Nearest Neighbor (NN) Variability, Shape
        NN_Shape_FE_Variability = 1.221;
        Size_Spread_FE_Variability = 0;
        Anisotropy_Spread_FE_Variability = 0;
        Anisotropy_Shape_FE_Variability = 0;


    case 5
        %% 5 : Anisotropy Variability, Spread
        Anisotropy_Spread_FE_Variability = 0.064;
        Size_Spread_FE_Variability = 0;
        Anisotropy_Shape_FE_Variability = 0;
        NN_Shape_FE_Variability = 0;


    case 6
        %% 6 : Anisotropy Variability, Shape
        Anisotropy_Shape_FE_Variability = 0.412;
        Size_Spread_FE_Variability = 0;
        Anisotropy_Spread_FE_Variability = 0;
        NN_Shape_FE_Variability = 0;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% patientID = {'rw';'gh';'he';'sc';'gz';'vm';...
%              'vl';'bb';'mf';'mb';'lq';'yp';...
%              'bs';'bj';'ts';'na';'bl';'cl';'sp';'es'};
% FE = [1.3 1.4 4.4 4.6 5.9 7.8 ...
%       12.7 13.4 14.8 16.2 16.6 19.2 ... 
%       23.1 25.5 29.0 29.6 30.0 32.9 35.4 57.8];  
  

%FE_1 = [0.5 1 2.5:2.5:12.5 15:5:60];
%FE_2 = [2:4 6:9 11:14 16:19 21:24 26:29 31:34 36:39 41:44 46:49 51:54 56:59];
%FE = sort([FE_1 FE_2]);

FE = [1 5 10 15 20 25 30 35 40 45 50];
%FE = [10 15 20 25 30 35 40 45 50];
%FE = [50];
%% new run...

sim_box_side = 80;     % um
hepatocyte_dim = 20;    % in um

fieldGridStep = 0.5;    % um for every grid point, 0.5 is nyquist for single sphere, however
spill = 2;      % um, to avoid NAN's during interpolation of boundary points




%%%%%%%%%%  MRI SIMULATION  %%%%%%%%%%

%jobManager = 'MRISIM-JM';
numWorkersSim = 31;

numProtons = 2000;  
%numProtons = 2;
step  = 0.0005; %msec        very important factor !!!
interval = 60; %msec, if interval needs to be changed, please have a look 
% at MriSimP and simulateP also since constants related to it may be hard 
% coded when echos are collected. This may be specially true for CPMG sims. 

patientIndx = 1;        %% dummy

%%%%%%%%%%%% Parameters that can be altered for proton motion simulation

%% Multipliers for field, wetToDryWtRatio and delX (from nominal)
%% Change the term in numerator to whatever value needs to be interrogated.
%% For example, for 3T, B0_multiplier = 3/1.5 = 2.
B0_multiplier= (B0)/B0;
wetToDryWtRatio_multiplier= (wetToDryWtRatio)/wetToDryWtRatio;
delX_multiplier  = (delX)/delX;

Dfactor = 1/2;
D = 0.76*Dfactor; % micron^2/msec, this is the value for human liver

cellBoundaryFlag = 1;   %% 0:off (unrestricted diffusion), 1:on (restricted diffusion)

%% 0:off (sinusoid unrestricted), proton can enter sinusoid
%% 1:on (sinusoid restricted), proton cannot enter sinusoid
sinusoidBoundaryFlag = 0;   %% there is no need to turn on boundaries.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%  GEOMETRY/FIELD GENERATION  & SIMULATION %%%%%%%%%%

%jobManager = 'MRISIM-JM';
numWorkersField = 40;
generateFieldFlag = 0;  %% 0: dont generate, 1: generate

%%%%%%%%%%  SIMULATION SELECTION &&&&&&&&
simSelect = 'CPMG';
useInstantExcitation = 1;	%fileread(strcat(codeRoot,'.git/HEAD'));

%%%%% Display variable settings before execution %%%%%%

disp('-------------SETTINGS-------------------');
disp(sprintf('wetToDryWtRatio =             %s',num2str(wetToDryWtRatio)));
disp(sprintf('delX =                        %s',num2str(delX)));
disp(sprintf('B0 = %s',num2str(B0)));
disp(sprintf('cellBiasFlag =                %s',num2str(cellBiasFlag)));
disp(sprintf('distributionVariabilityType = %s',num2str(distributionVariabilityType)));
disp(sprintf('numWorkersField =             %s',num2str(numWorkersField)));
disp(sprintf('numWorkersSim =               %s',num2str(numWorkersSim)));
disp(sprintf('numProtons =                  %s',num2str(numProtons)));
disp(sprintf('cellBoundaryFlag =            %s',num2str(cellBoundaryFlag)));
disp(sprintf('D =                           %s',num2str(D)));
disp(sprintf('B0_multiplier =               %s',num2str(B0_multiplier)));
disp(sprintf('wetToDryWtRatio_multiplier =  %s',num2str(wetToDryWtRatio_multiplier)));
disp(sprintf('delX_multiplier =             %s',num2str(delX_multiplier)));
disp(sprintf('useInstantExcitation =        %s',num2str(useInstantExcitation)));
%%%%%Prep settings to be saved

simOutput.simParams.wetToDryRatio = wetToDryWtRatio;
simOutput.simParams.delX = delX;
simOutput.simParams.B0 = B0;
simOutput.simParams.cellBiasFlag = cellBiasFlag;
simOutput.simParams.distributionVariabilityType = distributionVariabilityType;
simOutput.simParams.numWorkersField = numWorkersField;
simOutput.simParams.numWorkersSim = numWorkersSim;
simOutput.simParams.numProtons = numProtons;
simOutput.simParams.cellBoundaryFlag = cellBoundaryFlag;
simOutput.simParams.D = D;
simOutput.simParams.B0_multiplier = B0_multiplier;
simOutput.simParams.wetToDryWtRatio_multiplier = wetToDryWtRatio_multiplier;
simOutput.simParams.delX_multiplier = delX_multiplier;
simOutput.simParams.simSelect = simSelect;
simOutput.simParams.FErange = FE;
simOutput.simParams.useInstantExcitation = useInstantExcitation;
simOutput.simParams.simBoxSide = sim_box_side;
simOutput.simParams.sinusoidBoundaryFlag = sinusoidBoundaryFlag;
simOutput.simParams.fieldGridStep = fieldGridStep;
simOutput.simParams.hepatocyteDim = hepatocyte_dim;
simOutput.simParams.spill = spill;
simOutput.simParams.step = step;
simOutput.simParams.interval = interval;
simOutput.simParams.phaseValidation = 0; %this is only to run Nilesh's old code.  Unnecessary after Bloch validation
simOutput.simParams.phaseCycle = 'yes';


r.resultsDir = resultsDir;
r.cellBiasFlag = cellBiasFlag;
r.cellSigma = cellSigma;
r.distributionVariabilityType = distributionVariabilityType;
r.Size_Spread_FE_Variability = Size_Spread_FE_Variability;
r.Anisotropy_Spread_FE_Variability = Anisotropy_Spread_FE_Variability;
r.Anisotropy_Shape_FE_Variability = Anisotropy_Shape_FE_Variability;
r.NN_Shape_FE_Variability = NN_Shape_FE_Variability;


%% It is worth noting that the behavior of TE changed from previous revisions

%simOutput.simParams.TE = [1.22:1.22:20];  %logspace(log(0.1)/log(10),log(30)/log(10),15); %check this parameter

simOutput.simParams.TE = [2 4 6 8 10 12 14 16 18 20]; %runs 10/14
simOutput.simParams.TE = logspace(log(1.7)/log(10),log(30)/log(10),8);

%necessary params to set
%simOutput.runParams.FAExcite = [81:9:99];

simOutput.runParams(1).FAExcite = 84;
simOutput.runParams(1).FAEcho = 'x2';
simOutput.runParams(1).useInstantExcitation = 1;
simOutput.runParams(1).SimSelect = 'SE';

%simOutput.runParams(3).FAExcite = 114;
%simOutput.runParams(3).FAEcho = 'x2';
%simOutput.runParams(3).useInstantExcitation = 1;
%simOutput.runParams(3).SimSelect = 'SE';


%simOutput.runParams(1).FAExcite = 90;
%simOutput.runParams(1).FAEcho = 'x2';
%simOutput.runParams(1).useInstantExcitation = 1;
%simOutput.runParams(1).SimSelect = 'SE';

%simOutput.runParams(2).FAExcite = 96;
%simOutput.runParams(2).FAEcho = 'x2';
%simOutput.runParams(2).useInstantExcitation = 1;
%simOutput.runParams(2).SimSelect = 'SE';


%simOutput.runParams(3).FAExcite = 102;
%simOutput.runParams(3).FAEcho = 'x2';
%simOutput.runParams(3).useInstantExcitation = 1;
%simOutput.runParams(3).SimSelect = 'SE';

%simOutput.runParams(4).FAExcite = 108;
%simOutput.runParams(4).FAEcho = 'x2';
%simOutput.runParams(4).useInstantExcitation = 1;
%simOutput.runParams(4).SimSelect = 'SE';



%% attempt to set code revision and branch
try
    simOutput.codeBranch = fileread(strcat(codeRoot,'.git',filesep,'HEAD'));
    simOutput.codeRev = fileread(strcat(codeRoot,filesep,'.git',filesep,simOutput.codeBranch(6:end)));
    simOutput.codeSubPath = codeSubPath;
    simOutput.hostname = hostname;
catch
    simOutput.codeBranch = '';
    simOutput.codeRev = '';    
    simOutput.codeSubPath = codeSubPath;
    simOutput.hostname = hostname;
end

r.simOutput = simOutput;

if generateFieldFlag == 0
    disp(sprintf('Generate field?               No'));
else
    disp(sprintf('Generate field?               Yes')); 
end

disp('----------------------------------------');

answer = input('Are settings OK? (y/n):','s')
disp('----------------------------------------');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if strcmp(answer,'y')

    disp('------------- Beginning Execution ---------------------------');
    
hpcc=0;
if hpcc
    cluster = parcluster('hpcc_remote_r2014a');
    mkdir('/tmp/eamon/MdcsDataLocation/usc/hpcc/R2014a/remote');
else
    parpool('local',12);
end

if exist(tempFileName,'file')
    load(tempFileName);
    runcounter = size(simOutput.signals,2)+1;
else
    runcounter = 1;
end

    for FEselect = runcounter:length(FE)
        
	    [patientInfo,patientDir] = PreparePatientInfo(resultsDir,cellBiasFlag,cellSigma,FE(FEselect),distributionVariabilityType,Size_Spread_FE_Variability,Anisotropy_Spread_FE_Variability,Anisotropy_Shape_FE_Variability,NN_Shape_FE_Variability);
        patientDir
        %patientInfo

        %for runsIndx = 1

            patientDirRuns = [patientDir '/Run' num2str(1)];

            if generateFieldFlag == 1
                simDriverPatientsField
                %communicate_update('Finished calculating field','email');
            else
                %patientDirRuns = sprintf('~/Documents/labcode/IronMonteCarloA/precalc fields/3Tfields/FE-%d/BiasedDistribution4/Mean/Run1',FE(FEselect))
            	load(sprintf('%s/sphereInfo.mat',patientDirRuns));
    			load(sprintf('%s/delBzGridP.mat',patientDirRuns));
   				load(sprintf('%s/params.mat',patientDirRuns));
    			load(sprintf('%s/patientInfo.mat',patientDirRuns));
            end

            %myCluster = parcluster('Local12');
            %parjob = createJob(myCluster);
           
            simParams = simOutput.simParams;
        
            %simTask = createTask(parjob, @ParallelSim2, 1, {sphereInfo,patientInfo,delBzGridP,patientIndx,simParams,numProtons,simOutput});
            
            tic
            if hpcc == 1
                r.FEselect = FEselect;

                ClusterInfo.setWallTime('23:59:00');
                ClusterInfo.setQueueName('');
                %ClusterInfo.setWallTime('48:00:00');
                %ClusterInfo.setQueueName('largemem');
                job = batch(cluster,'ParallelSimCluster', ...
                            'AttachedFiles',{'ParallelSimCluster.m','Multi_Sim.m','CPMGSim.m','xrot.m','yrot.m','zrot.m','computeProtonPath.m','computeProtonPath2.m'},'Pool',numWorkersSim);

%                job = batch(cluster,'ParallelSimClusterLocalFields', ...
%                            'AttachedFiles',{'ParallelSimClusterLocalFields.m',...
%                            'ParallelSimCluster.m','Multi_Sim.m','CPMGSim.m',...
%                            'xrot.m','yrot.m','zrot.m','computeProtonPath.m',...
%                            'computeProtonPath2.m'},'Pool',numWorkersSim ...
%                            , 'Workspace',r);
                
                job
                wait(job)
                magOut = load(job,'magOut');
                simTime = toc;
            else
                magOut = ParallelSim2(sphereInfo,patientInfo,delBzGridP,patientIndx,simOutput.simParams,numProtons,simOutput);
                simTime = toc;
            end
            

                %% individual multipliers for B0, wetToDryWtRatio and delX will
                %% be evaluated



            flipAngleExcite = simOutput.runParams.FAExcite;
            flipAngleEcho = simOutput.runParams.FAEcho;

            simOutput.signals{runcounter}.faEx = flipAngleExcite;
            simOutput.signals{runcounter}.faEcho = simOutput.runParams.FAEcho;
            simOutput.signals{runcounter}.magnetizationSE = magOut;
            simOutput.signals{runcounter}.TE = simOutput.simParams.TE;
            simOutput.signals{runcounter}.simTime = simTime;
            simOutput.signals{runcounter}.FE = FE(FEselect);
            disp(sprintf('finished %0d',runcounter));
            save(sprintf('%s/%s_%s_temp_round3.mat',resultsSaveLoc,experimentName,hostname),'simOutput');  %resave after each run
            runcounter = runcounter + 1;

                                

				%communciate_update('Finished a simulation','email');


    end

else
    
    disp('Execution aborted.');
    
end
	time = clock;
	timeString = sprintf('%0d%02d%02d_%02d%02d',time(1),time(2),time(3),time(4),time(5))
    save(sprintf('%s/%s_%s_%s.mat',resultsSaveLoc,experimentName,timeString,hostname),'simOutput');
    msgTemp = sprintf('Finished a sim');
    disp(msgTemp);
    %communicate_update(msgTemp,'email');


