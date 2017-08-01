%Elaheh Rashedi

function [ speckle_matrix ] = Speckle_Density( layer1 , layer2 , layer3 , layer4 , N , M , R , C )    
    
    temp1 = layer2 - layer1 ;
    temp2 = layer3 - layer2;
    temp3 = layer4 - layer3;
    temp = (temp1.^2 + temp2.^2 + temp3.^2)/3 ;
    figure , imshow (temp,[]) ;
    
     temp (temp<0.02) = 0 ;
%     temp (temp>0) = 1 ;
%     figure , imshow (temp,[]) ;

 
    speckle_matrix = zeros (R,C) ; 

%     for j = 1:C                 
%         for i = 1:R
%             minM = j - (M-1)/2 ; if (minM<1) minM=1; end
%             maxM = j + (M-1)/2 ; if (maxM>C) maxM=C; end
%             minN = i - (N-1)/2 ; if (minN<1) minN=1; end
%             maxN = i + (N-1)/2 ; if (maxN>R) maxN=R; end
%             for jwin = minM:maxM
%                 for iwin=minN:maxN
%                     speckle_matrix(iwin,jwin) = mean2 (temp(minN:maxN,minM:maxM)) ; 
%                 end
%             end
%         end
%     end
    
    speckle_matrix = temp ;
    figure , imshow (speckle_matrix,[]) ;

end

