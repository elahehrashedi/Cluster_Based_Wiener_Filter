%Elaheh Rashedi

function cnr=CNR2(background_I,object_I)

    [M N]=size(background_I);

    %%making the image linear
    for i=1:M
        for j=1:N
           background_I(i,j)=10^(background_I(i,j)/10);
           object_I(i,j)=10^(object_I(i,j)/10);
        end
    end



    uo=mean2(object_I);
    ub=mean2(background_I);

    So=std2(object_I);
    Sb=std2(background_I);

    cnr=(uo-ub)/sqrt(So^2+Sb^2)

end