%Elaheh Rashedi

function mysnr=SNR2(objectBACK,objectFRONT) %BACKGROUND , FILTERED IMAGE

    homo = 5 ; %homogeneaos regins 
    repeat= 9 ; % repeat regins of interests
    mycol = [10 , 140 , 250 , 035 , 150 ,  045 , 160 , 245 , 105 ] ; %X in image
    myrow = [40 , 050 , 080 , 160 , 180 ,  250 , 220 , 245 , 305 ] ; %Y in image
    background_I = objectBACK (5:4+homo,5:4+homo);
    
    mysnr = 0 ;
    for i=1:repeat
        newsnr = snr (objectFRONT( myrow(i):myrow(i)+homo-1 , mycol(i):mycol(i)+homo-1  ) , background_I ); 
        mysnr = mysnr + newsnr ;
    end
    
    mysnr = mysnr / repeat ;
    
end