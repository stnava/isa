library( ANTsR )
img = antsImageRead("final_iter.nii.gz")
antsSetSpacing( img , antsGetSpacing(img)*30 )
img = resampleImage( img, c(4,4,4) )
bimg = thresholdImage(img,10,Inf)
kfn = "curvature_final_iter.nii.gz"
if ( !exists( kfn ) )
  {
  kimg = weingartenImageCurvature( img, sigma=2.0 )
  antsImageWrite( kimg, kfn )
  } else kimg = antsImageRead( kfn )
skimg = smoothImage( kimg, 3, sigmaInPhysicalCoordinates = FALSE )
rp1 = matrix( c(90,180,90), ncol = 3 )
rp2 = matrix( c(90,180,270), ncol = 3 )
rp3 = matrix( c(90,180,180), ncol = 3 )
rp  = rbind( rp1, rp3, rp2 )
skimgtr = iMath(skimg,"TruncateIntensity",0.005,0.995)
antsrSurf( bimg, list( skimgtr  ), filename='~/Downloads/tempk',
  rotationParams = rp, colormap = c("jet"),
  overlayLimits=range(skimgtr) )
# antsrVol( ... )
# antsrVol( img , filename='~/Downloads/avol' )


 img1 = antsImageRead( getANTsRData( "r16" ) ) %>%
   resampleImage( c(4,4) )
 img2 = antsImageRead( getANTsRData( "r64" ) ) %>%
   resampleImage( c(4,4) )
 img3 = antsImageRead( getANTsRData( "r27" ) ) %>%
   resampleImage( c(4,4) )
 img4 = antsImageRead( getANTsRData( "r30" ) ) %>%
   resampleImage( c(4,4) )
 reg1 = antsRegistration( img1, img2, 'SyN' )
 reg2 = antsRegistration( img1, img3, 'SyN' )
 reg3 = antsRegistration( img1, img4, 'SyN' )
w1 = antsImageRead( reg1$fwdtransforms[1] )
w2 = antsImageRead( reg2$fwdtransforms[1] )
w3 = antsImageRead( reg3$fwdtransforms[1] )
mask = getMask( img1 )
x = list( w1, w2, w3 )
dd = deformationFieldPCA( )
