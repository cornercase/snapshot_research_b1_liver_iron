addpath(fullfile('/Users/eamon/repos/research_code/Useful Utilities/queryMySQL/', 'src'));
javaaddpath('/Users/eamon/mysql-connector-java-5.1.34-bin.jar');

%% import classes
import edu.stanford.covert.db.*;


fileID = fopen('dirlist.txt');
dirs = textscan(fileID,'%s', 'Delimiter','\n');
fclose(fileID);

if mod(length(dirs{1}),4) 
    error('directory file is not mod4, check scan list');
end
patientList = cell(0);
for n=0:(length(dirs{1})/4-1)
    clear qstring;
    patient = struct('acrostic',-1,'study_id',-1,'dob',-1,'sex',-1,'r2',-1,'r2s',-1,'disease',-1,'examdate',-1,'ageatexam','-1');
    
    b1 = struct('patRoot','','patInfo','','l',struct('slow',-1,'fast',-1),'h',struct('slow',-1,'fast',-1));
    
    for m=1:4
        
        ind = n*4+m;
        p = dirs{1}{ind};
        if regexpi(p,'/Volumes/data/3T/3T_[A-Z0-9_/]+(1.5T)[ a-zA-Z0-9_/]+')
            field = '1.5';
        elseif regexpi(p,'/Volumes/data/3T/3T_[A-Z0-9_/]+(3T|3.0T)[a-zA-Z0-9_/]+')
            field = '3';
        elseif strfind(p,'abd_iron_study - 477392487')  %hack to fix one patient's bad named scan
            field = '3';
        else
            p
            error('no known field strength');
        end
        
        if regexpi(p,'[/a-zA-z0-9_](fast|short_TE)[/a-zA-z0-9_]')
            type = 'fast';
            if strcmp(field,'3')
                b1.h.fast = p(1:end-3);
            else
                b1.l.fast = p(1:end-3);
            end
        elseif regexpi(p,'[/a-zA-z0-9_](std|long_TE)[/a-zA-z0-9_]')
            type = 'slow';
            if strcmp(field,'3')
                b1.h.slow = p(1:end-3);
            else
                b1.l.slow = p(1:end-3);
            end
        else
            p
            error('no known speed');
        end
        
        pid = regexpi(p,'[/a-zA-z0-9_](3T_)[0-9][0-9][0-9][/a-zA-z0-9_]');
        pid = p(pid+4:pid+6);
        %pid = str2num(pid);
        patient.study_id = pid;
        
        
    end
    
    db = MySQLDatabase('woodrc1', 'wood_db', 'wooddb_read_only', 'WoodIronDB');

    fileID = fopen('patient_demographics_query.sql');
    query_text = textscan(fileID,'%s', 'CollectOutput',1);
    fclose(fileID);
    qstring = strjoin(query_text{1}',' ');
    qstring = [qstring '''' patient.study_id ''''];

    db.prepareStatement(qstring);% WHERE id = "{Si}"', 10001);
    result = db.query();
    
    patient.sex = result.Gender;
    patient.disease = result.ClinicalStatus;
    patient.r2 = result.R2_Liver;
    patient.r2s = result.R2s_Liver;
    patient.examdate = result.DOE;
    patient.ageatexam = result.Age_At_Scan;
    b1.patInfo = patient;
    
    patientList{end+1} = b1;

end
    
patientList = recon_b1(patientList);

%dirty hacks
patientList{1}.patInfo.r2s(1) = 58.5;
patientList{2}.patInfo.r2(4) = 193.65;

        
%%

tcell = cell(31,10);

tcell{1,1} = 'r2'
tcell{1,2} = 'r2s'
tcell{1,3} = '3T fast mean'
tcell{1,4} = '3T fast STD'
tcell{1,5} = '3T slow mean'
tcell{1,6} = '3T slow STD'
tcell{1,7} = '1.5T fast mean'
tcell{1,8} = '1.5T fast STD'
tcell{1,9} = '1.5T slow mean'
tcell{1,10} = '1.5T slow STD'


for n=1:30
    tcell{n+1,1}= patientList{n}.patInfo.r2(patientList{n}.useIndex)
    tcell{n+1,2}= patientList{n}.patInfo.r2s(patientList{n}.useIndex)
    tcell{n+1,3}= patientList{n}.res.highFast.mean
    tcell{n+1,4}= patientList{n}.res.highFast.std
    tcell{n+1,5}= patientList{n}.res.highSlow.mean
    tcell{n+1,6}= patientList{n}.res.highSlow.std
    tcell{n+1,7}= patientList{n}.res.lowFast.mean
    tcell{n+1,8}= patientList{n}.res.lowFast.std
    tcell{n+1,9}= patientList{n}.res.lowSlow.mean
    tcell{n+1,10}= patientList{n}.res.lowSlow.std
end



fname = 'patientListProcessed.csv';
fid = fopen(fname, 'w') ;
fprintf(fid, '%s,', tcell{1,1:end-1}) ;
fprintf(fid, '%s\n', tcell{1,end}) ;
fclose(fid) ;


dlmwrite(fname, tcell(2:end,:), '-append') ;


save('patientListProcessed','patientList');


