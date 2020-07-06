name = {
    ' bar',
% ' bottle',
    ' building',
% ' camera',
    ' character',
    ' earth',
    ' flower',
% ' kitchen',
% ' lemon',
% ' pc_desktop',
% ' pcgame',
% ' rainier',
% ' room',
    ' shop',
% ' street',
% ' tatemono',
% ' deskchair',
% ' wedding'
    };

Q = 10:25;
for i = 1:length(name)
    parfor crf = Q
        crf_str = [' ', int2str(crf)];
        system(string(strcat('wsl source codec265.sh', name(i), '.ppm', crf_str)));
    end
    eva(name{i}, Q);
end
