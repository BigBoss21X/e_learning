Sys.setlocale("LC_ALL", "en_US.UTF-8") 
# install.packages("extrafont")
library(extrafont) ## 잊지마세요 package 불러오기!
font_import() # // 설치된 모든 폰트 가져오기

# Generate a vector of 100 values between -4 and 4
t_distribution <- function (df1 = df1, df2 = df2, df3 = df3) {
  
  x <- seq(-4, 4, length = 1000)
  
  # Simulate the t-distribution
  y_1 <- dt(x, df = df1)
  y_2 <- dt(x, df = df2)
  y_3 <- dt(x, df = df3)
  
  par(family="AppleGothic")
  # Plot the t-distributions
  plot(x, y_1, type = "l", lwd = 2, xlab = "t-value", ylab = "Density", 
       main = paste0("t-분포의 비교, df = ", as.character(df3)), col = "black", ylim = c(0, 0.4))
  lines(x, y_2, col = "red")
  lines(x, y_3, col = "blue")
  
  # Add a legend
  legend("topright", c(paste0("df = ", as.character(df1)), 
                       paste0("df = ", as.character(df2)), 
                       paste0("df = ", as.character(df3))
                       ), 
         col = c("black", "red", "blue"), 
         title = "t-분포", lty = 1)
  return(print("Done!!"))
}

t_lengths <- c(6, 10, 20, 30, 40, 50)
for (i in t_lengths) {
  t_distribution(df1 = 2, df2 = 6, df3 = i)
  Sys.sleep(3)
}

# Chapter 2. 대응표본
