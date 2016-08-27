library( ANTsR )
img = antsImageRead("final_iter.nii.gz")
antsSetSpacing( img , antsGetSpacing(img)*30 )
r = 2
img = resampleImage( img, c(r,r,r) )
bimg = thresholdImage(img,10,Inf)
kfn = "curvature_final_iter.nii.gz"
# if ( !exists( kfn ) ) {
  kimg = weingartenImageCurvature( img, sigma = r )
  antsImageWrite( kimg, kfn )
#  } else kimg = antsImageRead( kfn )
skimg = smoothImage( kimg, 3.0, sigmaInPhysicalCoordinates = FALSE )
rp1 = matrix( c(90,180,90), ncol = 3 ) # keep left
rp2 = matrix( c(90,180,270), ncol = 3 ) # keep right
rp3 = matrix( c(0,0,180), ncol = 3 ) # keep top
rp4 = matrix( c(0,180,180), ncol = 3 ) # keep bottom
rp  = rbind( rp1, rp2, rp3, rp4 )
skimgtr = iMath(skimg,"TruncateIntensity",0.002,0.998)
antsrSurf( bimg, list( skimgtr  ),
  rotationParams = rp, colormap = c("jet"),
  overlayLimits=range(skimgtr),
  filename='~/Downloads/tempk' )
antsrVol( bimg, list( skimgtr ), rotationParams=rp,
  overlayLimits=range(skimgtr), magnificationFactor=1.6,
  filename='~/Downloads/tempv' )
