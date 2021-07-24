function [] = draw_image(img,fignum)

figure(fignum)
cla
imagesc(img)
%colormap(flipud(gray))
colormap((jet))
axis equal
colorbar
 set(gca, 'XTick', 0.5:length(img)+0.5, 'YTick', 0.5:length(img)+0.5, ...  
          'XLim', [-0.5 length(img)+1.5], 'YLim', [-0.5 length(img)+1.5], ...
          'xticklabel', [], 'yticklabel', [], ...
          'GridLineStyle', '-', 'XGrid', 'on', 'YGrid', 'on');
end

