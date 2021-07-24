
clear all
%close all


load A
A1=A;
load dv

data=dv (:,2:end);


nn=size(data,2);

draw_image(1, 3)
xx=A'*dv;
% return

u=reshape(xx,[ 64, 64,   100]);

A_1 = A.';
A_1 = reshape(A.', [64, 64, 864]);

sense_matrix = zeros(64, 64);
for i=1:864
    sense_matrix = sense_matrix + A_1(:,:,i);
    %draw_image(sense_matrix, 1);
    %draw_image(A_1(:,:,i), 2);
end
figure(3)
draw_image(sense_matrix, 1);

sense_matrix_2 =  sum(A_1, 3);
draw_image(sense_matrix, 2);

%%


for iii=1:1:nn
  kk=iii+1;
    
%     v=u(5:45,5:45);
ttt=u(:,:,iii);
xx=ttt(:);

xxxx(kk)=length(find(xx));

    %imagesc(u(:,:,kk));

    %colormap jet; view(2)
    %draw_image(u(:,:,kk),1)
    string = sprintf("C:/Users/UKGC/Desktop/FYP/Datasets/ManuchImages/OG100/raw_threshold/images/image%d.png", kk);
    image = LBPTH(u(:,:,kk), 0.75);
    imwrite(image, string)
 
 title(iii)


%drawnow



end

%%
for i = 2:100
    k = u(:,:,i);
    uu = abs(k);
    uu = uu * (1/255); 
    string = sprintf("C:/Users/UKGC/Desktop/FYP/Datasets/ManuchImages/OG100/raw/images/image%d.png", i);
    imwrite(uu, string);
    
    string = sprintf("C:/Users/UKGC/Desktop/FYP/Datasets/ManuchImages/OG100/raw_threshold/images/image%d.png", i);
    image = LBPTH(uu, 0.75);
    imwrite(image, string)
    
    %draw_image(uu, 1)
    %draw_image(image, 2)
end

