# this is based on the output of the following example:
# https://github.com/ntustison/TemplateBuildingExample
library( ANTsR )
defs = Sys.glob( 'TemplateFaces/*[0-9]Warp.nii.gz' )
template = antsImageRead( "TemplateFaces/T_template0.nii.gz" )
msk = getMask( template ) %>% iMath( "MD", 8 )
# msk = antsImageRead( "eye.nii.gz" )
wlist = list( )
for ( i in 1:length( defs ) ) wlist[[ i ]] = antsImageRead( defs[i] )
####
dpca = multichannelPCA( wlist, msk, pcaOption='randPCA', verbose=FALSE )
####
for ( ww in 1:ncol( dpca$pca$v ) )
  {
  print( ww )
  warpTx = antsrTransformFromDisplacementField( dpca$pcaWarps[[ww]] *
     ( 1000 / dpca$pca$d[ww] ) )
  # compose several times to get a visual effect
  wtxlong = list( ) ; for ( i in 1:50 ) wtxlong[[i]]=warpTx
  warped = applyAntsrTransform( wtxlong, data = template,
    reference = template )
  for ( kk in 1:6 ) {
    plot( template )
    plot( warped )
    }
  }

# now make a "random" face
warpTx = antsrTransformFromDisplacementField(
  dpca$pcaWarps[[2]] * 1.5 -
    dpca$pcaWarps[[6]] * 1 +
      dpca$pcaWarps[[3]] * 2 -
        dpca$pcaWarps[[7]] * 3 -
          dpca$pcaWarps[[1]] * 1 )
# compose several times to get a visual effect
wtxlong = list( ) ; for ( i in 1:25 ) wtxlong[[i]]=warpTx
warped = applyAntsrTransform( wtxlong, data = template,
  reference = template )
for ( kk in 1:6 ) {
  plot( template )
  plot( warped )
  }
