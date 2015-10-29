
plot.nnet<-function(mod.in,nid=T,all.out=T,all.in=T,wts.only=F,rel.rsc=5,circle.cex=5,node.labs=T,
  line.stag=NULL,cex.val=1,alpha.val=1,circle.col='lightgrey',pos.col='black',neg.col='grey',...){

  require(scales)
	
  #gets weights for neural network, output is list
  #if rescaled argument is true, weights are returned but rescaled based on abs value
  nnet.vals<-function(mod.in,nid,rel.rsc){

    library(scales)
    layers<-mod.in$n
    wts<-mod.in$wts
    if(nid) wts<-rescale(abs(wts),c(1,rel.rsc))

    indices<-matrix(seq(1,layers[1]*layers[2]+layers[2]),ncol=layers[2])
    out.ls<-list()
    for(i in 1:ncol(indices)){
      out.ls[[paste('hidden',i)]]<-wts[indices[,i]]
      }

    if(layers[3]==1) out.ls[['out 1']]<-wts[(max(indices)+1):length(wts)]
    else{
      out.indices<-matrix(seq(max(indices)+1,length(wts)),ncol=layers[3])
      for(i in 1:ncol(out.indices)){
        out.ls[[paste('out',i)]]<-wts[out.indices[,i]]
        }
      }

    out.ls

    }

  wts<-nnet.vals(mod.in,nid=F)

  if(wts.only) return(wts)

  #par(mar=numeric(4),oma=numeric(4),family='serif')
  library(scales)
  struct<-mod.in$n
  x.range<-c(0,100)
  y.range<-c(0,100)
  #these are all proportions from 0-1
	if(is.null(line.stag)) line.stag<-0.011*circle.cex/2
  layer.x<-seq(0.17,0.9,length=3)
  bias.x<-c(mean(layer.x[1:2]),mean(layer.x[2:3]))
  bias.y<-0.95
	in.col<-bord.col<-circle.col
  circle.cex<-circle.cex
	
  #get variable names from nnet object
	if(is.null(mod.in$call$formula)){
		x.names<-colnames(eval(mod.in$call$x))
		y.names<-colnames(eval(mod.in$call$y))
		}
	else{
		forms<-eval(mod.in$call$formula)
		dat.names<-model.frame(forms,data=eval(mod.in$call$data))
		y.names<-as.character(forms)[2]
		x.names<-names(dat.names)[!names(dat.names) %in% y.names]
		}
	
	#initiate plot
  plot(x.range,y.range,type='n',axes=F,ylab='',xlab='',...)

  #function for getting y locations for input, hidden, output layers
  #input is integer value from 'struct'
  get.ys<-function(lyr){
    spacing<-diff(c(0*diff(y.range),0.9*diff(y.range)))/max(struct)
    seq(0.5*(diff(y.range)+spacing*(lyr-1)),0.5*(diff(y.range)-spacing*(lyr-1)),
      length=lyr)
    }

  #function for plotting nodes
  #'layer' specifies which layer, integer from 'struct'
  #'x.loc' indicates x location for layer, integer from 'layer.x'
  #'layer.name' is string indicating text to put in node
  layer.points<-function(layer,x.loc,layer.name,cex=cex.val){
		x<-rep(x.loc*diff(x.range),layer)
    y<-get.ys(layer)
    points(x,y,pch=21,cex=circle.cex,col=in.col,bg=bord.col)
    if(node.labs) text(x,y,paste(layer.name,1:layer,sep=''),cex=cex.val)
    if(layer.name=='I' & node.labs){
      text(x-line.stag*diff(x.range),y,x.names,pos=2,cex=cex.val)
    	}	
    if(layer.name=='O' & node.labs)
      text(x+line.stag*diff(x.range),y,y.names,pos=4,cex=cex.val)
    }

  #function for plotting bias points
  #'bias.x' is vector of values for x locations
  #'bias.y' is vector for y location
  #'layer.name' is  string indicating text to put in node
  bias.points<-function(bias.x,bias.y,layer.name,cex,...){
    for(val in 1:length(bias.x)){
      points(
        diff(x.range)*bias.x[val],
        bias.y*diff(y.range),
        pch=21,col=in.col,bg=bord.col,cex=circle.cex
        )
      if(node.labs)
        text(
          diff(x.range)*bias.x[val],
          bias.y*diff(y.range),
          paste(layer.name,val,sep=''),
          cex=cex.val
        )
      }
    }

  #function creates lines colored by direction and width as proportion of magnitude
  #use 'all.in' argument if you want to plot connection lines for only a single input node
  layer.lines<-function(mod.in,h.layer,layer1=1,layer2=2,out.layer=F,nid,rel.rsc,all.in,pos.col,
  	neg.col,...){

    x0<-rep(layer.x[layer1]*diff(x.range)+line.stag*diff(x.range),struct[layer1])
    x1<-rep(layer.x[layer2]*diff(x.range)-line.stag*diff(x.range),struct[layer1])

    if(out.layer==T){

      y0<-get.ys(struct[layer1])
      y1<-rep(get.ys(struct[layer2])[h.layer],struct[layer1])
      src.str<-paste('out',h.layer)

      wts<-nnet.vals(mod.in,nid=F,rel.rsc)
      wts<-wts[grep(src.str,names(wts))][[1]][-1]
      wts.rs<-nnet.vals(mod.in,nid=T,rel.rsc)
      wts.rs<-wts.rs[grep(src.str,names(wts.rs))][[1]][-1]

      cols<-rep(pos.col,struct[layer1])
      cols[wts<0]<-neg.col

      if(nid) segments(x0,y0,x1,y1,col=cols,lwd=wts.rs)
      else segments(x0,y0,x1,y1)

      }
      
    else{

      if(is.logical(all.in)) all.in<-h.layer
      else all.in<-which(x.names==all.in)

      y0<-rep(get.ys(struct[layer1])[all.in],struct[2])
      y1<-get.ys(struct[layer2])
      src.str<-'hidden'

      wts<-nnet.vals(mod.in,nid=F,rel.rsc)
      wts<-unlist(lapply(wts[grep(src.str,names(wts))],function(x) x[all.in+1]))
      wts.rs<-nnet.vals(mod.in,nid=T,rel.rsc)
      wts.rs<-unlist(lapply(wts.rs[grep(src.str,names(wts.rs))],function(x) x[all.in+1]))

      cols<-rep(pos.col,struct[layer2])
      cols[wts<0]<-neg.col

      if(nid) segments(x0,y0,x1,y1,col=cols,lwd=wts.rs)
      else segments(x0,y0,x1,y1)

      }

    }

  bias.lines<-function(bias.x,mod.in,nid,rel.rsc,all.out,pos.col,neg.col,...){

    if(is.logical(all.out)) all.out<-1:struct[3]
    else all.out<-which(y.names==all.out)
    
    for(val in 1:length(bias.x)){

      wts<-nnet.vals(mod.in,nid=F,rel.rsc)
      wts.rs<-nnet.vals(mod.in,nid=T,rel.rsc)

      if(val==1){
        wts<-wts[grep('out',names(wts),invert=T)]
        wts.rs<-wts.rs[grep('out',names(wts.rs),invert=T)]
        }

      if(val==2){
        wts<-wts[grep('out',names(wts))]
        wts.rs<-wts.rs[grep('out',names(wts.rs))]
        }

      cols<-rep(pos.col,length(wts))
      cols[unlist(lapply(wts,function(x) x[1]))<0]<-neg.col
      wts.rs<-unlist(lapply(wts.rs,function(x) x[1]))

      if(nid==F){
        wts.rs<-rep(1,struct[val+1])
        cols<-rep('black',struct[val+1])
        }

      if(val==1){
        segments(
          rep(diff(x.range)*bias.x[val]+diff(x.range)*line.stag,struct[val+1]),
          rep(bias.y*diff(y.range),struct[val+1]),
          rep(diff(x.range)*layer.x[val+1]-diff(x.range)*line.stag,struct[val+1]),
          get.ys(struct[val+1]),
          lwd=wts.rs,
          col=cols
          )
        }

      if(val==2){
        segments(
          rep(diff(x.range)*bias.x[val]+diff(x.range)*line.stag,struct[val+1]),
          rep(bias.y*diff(y.range),struct[val+1]),
          rep(diff(x.range)*layer.x[val+1]-diff(x.range)*line.stag,struct[val+1]),
          get.ys(struct[val+1])[all.out],
          lwd=wts.rs[all.out],
          col=cols[all.out]
          )
        }

      }
    }

  #use functions to plot connections between layers
  #bias lines
  bias.lines(bias.x,mod.in,nid=nid,rel.rsc=rel.rsc,all.out=all.out,pos.col=alpha(pos.col,alpha.val),
  	neg.col=alpha(neg.col,alpha.val))

  #layer lines, makes use of arguments to plot all or for individual layers
  #starts with input-hidden
  #uses 'all.in' argument to plot connection lines for all input nodes or a single node
  if(is.logical(all.in)){
    mapply(
      function(x) layer.lines(mod.in,x,layer1=1,layer2=2,nid=nid,rel.rsc=rel.rsc,all.in=all.in,
      	pos.col=alpha(pos.col,alpha.val),neg.col=alpha(neg.col,alpha.val)),
      1:struct[1]
      )
    }
  else{
    node.in<-which(x.names==all.in)
    layer.lines(mod.in,node.in,layer1=1,layer2=2,nid=nid,rel.rsc=rel.rsc,all.in=all.in,
    	pos.col=alpha(pos.col,alpha.val),neg.col=alpha(neg.col,alpha.val))
    }

  #lines for hidden-output
  #uses 'all.out' argument to plot connection lines for all output nodes or a single node
  if(is.logical(all.out))
    mapply(
      function(x) layer.lines(mod.in,x,layer1=2,layer2=3,out.layer=T,nid=nid,rel.rsc=rel.rsc,
        all.in=all.in,pos.col=alpha(pos.col,alpha.val),neg.col=alpha(neg.col,alpha.val)),
      1:struct[3]
      )
  else{
    all.out<-which(y.names==all.out)
    layer.lines(mod.in,all.out,layer1=2,layer2=3,out.layer=T,nid=nid,rel.rsc=rel.rsc,
    	pos.col=pos.col,neg.col=neg.col)
    }

  #use functions to plot nodes
  layer.points(struct[1],layer.x[1],'I')
  layer.points(struct[2],layer.x[2],'H')
  layer.points(struct[3],layer.x[3],'O')
  bias.points(bias.x,bias.y,'B')

  }
