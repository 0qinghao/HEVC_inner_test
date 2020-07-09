function eva(yuvname, crf)
    yuvname = strtrim(yuvname);
    src = imread(strrep(yuvname, 'yuv', ''));
    dst = {};
    for i = 1:length(crf)
        dst{i} = imread(strcat(yuvname, '_', int2str(crf(i)), '_rebuild.ppm'));
        dst{i} = jpeg_ycbcr2rgb(dst{i});
    end

    headsize = 27 + 49 + 12;
    peaksnr = zeros(1, length(crf));
    snrval = peaksnr;
    ssimval = peaksnr;
    filesize_KByts = peaksnr;
    MOSpsnr = peaksnr;
    MOSssim = peaksnr;
    filenamestr = cell(1, length(crf));
    for i = 1:length(crf)
        hevcfile = dir(strcat(yuvname, '_', int2str(crf(i)), '.h265'));
        filenamestr(i) = {hevcfile.name};
        % dst_downsample = imread(file.name);
        % dst = inv_smooth(dst_downsample);
        % writename = strcat({file.name},'inv_smooth.ppm');
        % imwrite(dst,writename{1});
        [peaksnr(i), snrval(i)] = psnr(src, dst{i})
        [ssimval(i), ~] = ssim(src, dst{i});
        filesize_KByts(i) = (hevcfile.bytes - headsize) / 1024;
        MOSpsnr(i) = -24.3816 * (0.5 - 1 ./ (1 + exp(-0.56962 * (peaksnr(i) - 27.49855)))) + 1.9663 * peaksnr(i) - 2.37071;
        MOSssim(i) = 2062.3 * (1 / (1 + exp(-11.8 * (ssimval(i) - 1.3))) + 0.5) + 40.6 * ssimval(i) - 1035.6;
    end
    compress_ratio = 1 ./ (filesize_KByts * 1024 / (1920 * 1080 * 3));
    tabletitle = {'filename', 'size_KB', 'compress_ratio', 'SNR', 'PSNR', 'SSIM', 'PSNR2MOS', 'SSIM2MOS'};
    csvdata = table(filenamestr(:), filesize_KByts(:), compress_ratio(:), snrval(:), peaksnr(:), ssimval(:), MOSpsnr(:), MOSssim(:), 'VariableNames', tabletitle);
    writetable(csvdata, [yuvname, '_evaluation.csv']);
    % end

    recycle('on');
    % delete('*.ppm.jpg')
end
