function om=tfilter(im,rang) 
for i=1:size(im,1)
    for j=1:size(im,2)
        if ( rang(1,1)< im(i,j,1) && rang(2,1)> im(i,j,1) && rang(1,2)< im(i,j,2) && rang(2,2)> im(i,j,2) && rang(1,3)< im(i,j,3) && rang(2,3)> im(i,j,3) )
            
        else
            im(i,j,1)=0;
            im(i,j,2)=0;
            im(i,j,3)=0;
        end
       
    end
end
om=im;
end