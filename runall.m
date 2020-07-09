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

yuvname = name;
for i = 1:length(name)
    yuvname{i} = strcat(name{i}, 'yuv.ppm');
    rgb = imread([strtrim(name{i}), '.ppm']);
    yuv = jpeg_rgb2ycbcr(rgb);
    imwrite(yuv, strtrim(yuvname{i}));
end
% for i = 1:length(name)
%     rgbname = [strtrim(name{i}), '.ppm'];
%     yuvname = [strtrim(name{i}), 'yuv.ppm'];
%     rgb = imread(rgbname);
%     yuv = jpeg_rgb2ycbcr(rgb);
%     imwrite(yuv, yuvname);
% end
Q = 10:25;
for i = 1:length(yuvname)
    parfor crf = Q
        crf_str = [' ', int2str(crf)];
        system(string(strcat('wsl source codec265.sh', yuvname(i), crf_str)));
    end
    eva(yuvname{i}, Q);
end
