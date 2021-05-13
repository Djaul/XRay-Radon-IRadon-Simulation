function [sinogram ,A]= radongui(image, angle, beam_number, handles)

%load the image and take inputs


number_of_projections = 1; %input

A = linspace(1,beam_number,beam_number); %output 2

%find the size of image
image_size = size(image , 1);
xcoor = -image_size/2:image_size/2; %grid between -M/2 and M/2
ycoor = -image_size/2:image_size/2; 
 

T = linspace( (-image_size*sqrt(2))/2 , (image_size*sqrt(2))/2 , beam_number ) ; %t vektörü
 
sinogram = zeros(number_of_projections , beam_number); 
%total sinogram that we will obtain in the end


for i=1:number_of_projections %for each angle
for j=1:beam_number  %for each beam 
    
    %found x points from y values
    known_x(2,:) = -image_size/2:image_size/2;    %the grid's known x values
    
    %found y points from x values
    known_y(1,:) = -image_size/2:image_size/2;    %the grid's known y values
    
     %find the unknown coordinates from line equation
     for c=1:1:(image_size+1)
        known_x(1,c) = (T(j) - ycoor(c) * sind( angle(i) ) ) / cosd(angle(i)) ;
        known_y(2,c) = (T(j) - xcoor(c) * cosd(angle(i)) ) / sind(angle(i));
     end
        
     uniquelistx = unique(known_x','rows')'; %list the unique coordinates
     uniquelisty = unique(known_y','rows')';
     
     concat = [uniquelistx uniquelisty]; %add the unique lists one after another
 
     for temprw = 1:2
         clmn=1;
         conc = concat';
         sizec = size(conc);
         for temp = 1:sizec
             if (concat(temprw,clmn) > -image_size/2 && concat(temprw,clmn) < image_size/2)
                clmn = clmn + 1; %pass to next column
             else
                concat (:,clmn) = [];  %delete column if out of bound
             end
         end
     end
     
    mylist = sortrows(concat'); %adjust the order in the list
    listsize = size(mylist,1);
    
    hipot1 = zeros(listsize-1);
    offsetx1 = zeros(listsize-1); 
    offsety1 = zeros(listsize-1);

    
 for point=1:(listsize-1) %for each found point
     
     foundx = ( mylist(point+1,1) + mylist(point,1) ) / 2 ;
     offsetx = image_size/2 + ceil(foundx); 
 
     foundy = ( mylist(point+1,2) + mylist(point,2) ) / 2 ;
     offsety = image_size/2 - floor(foundy);
 
     hipot = sqrt((mylist(point+1,1)-mylist(point,1)) * (mylist(point+1,1)-mylist(point,1)) + (mylist(point+1,2) - mylist(point,2)) * (mylist(point+1,2)-mylist(point,2)) );

     hipot1(point) = hipot;
     offsetx1(point) = offsetx;
     offsety1(point) = offsety;
    
     %the pixel value in the corresponding point
     pixel_value = image(offsetx,offsety);
     %sum up the product of the obtained distances and pixelvalues
     sinogram(i,j) = sinogram(i,j) + hipot*pixel_value; 
     
 end
                                        
end
end


end