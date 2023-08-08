# install.packages("ggplot2")

library(cluster)
library(ggplot2)


set.seed(123)
data = matrix(rnorm(200),ncol=2)

Wcss = function(data,k){
  kmeams_obj = kmeans(data, centers = k)
  return (kmeams_obj$tot.withinss)
}

elbowMethod = function(data,max_k){
  wcss = vector()
  for(k in 1:max_k){
    wcss[k] = Wcss(data,k)
  }
  
  line_start = c(1, wcss[1])
  line_end = c(max_k, wcss[max_k])
  
  distances = abs((line_end[2] - line_start[2]) * (1:max_k - line_start[1]) -
               (line_end[1] - line_start[1]) * (wcss - line_start[2])) /
              sqrt((line_end[2] - line_start[2])^2 + (line_end[1] - line_start[1])^2)
  largest_distance_index = which.max(distances)
  
  plot = ggplot(data.frame(k=1:max_k,wcss=wcss),aes(x=k,y=wcss))+
    geom_line()+
    geom_point()+
    geom_segment(aes(x = 1, y = wcss[1], xend = max_k, yend = wcss[max_k]), linetype = "dashed") +
    geom_point(aes(x = largest_distance_index, y = wcss[largest_distance_index]), color = "red", size = 3) +
    labs(x="Number of Clusters",y="WCSS")+
    ggtitle("Elbow Method")
  
  return(plot)
}

elbowMethod(data,max_k=10)
