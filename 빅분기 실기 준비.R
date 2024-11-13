df = iris
df$Species = ifelse(iris$Species == 'setosa', '0', '1') # 이진분류로 셋팅
df$Species = as.factor(df$Species)

set.seed(2024) # 랜덤시드고정
idx <- createDataPartition(df$Species, p = 0.8, list = F)
train = df[idx, ]
test = df[-idx, ]
test = test %>% select(-Species)
# 결측치 삽입
train[1, 'Sepal.Length'] <- NA
test[1, 'Sepal.Length'] <- NA  

# 이상치 삽입
train[1, 'Sepal.Width'] <- 150
############################################


### 문제 : 붓꽃의 종(Species)을 분류해보자 ----

### - 데이터의 결측치, 이상치에 대해 처리하고
### - 분류모델을 사용하여 정확도, F1 score, AUC 값을 산출하시오. 
### - 제출은 result 변수에 담아 양식에 맞게 제출하시오


library(dplyr)
library(caret)
library(randomForest)
library(ModelMetrics)




median_sl = train$Sepal.Length %>% median(na.rm = T) # 주의 na.rm = T
train$Sepal.Length = ifelse(is.na(train$Sepal.Length), median_sl, train$Sepal.Length)
test$Sepal.Length = ifelse(is.na(test$Sepal.Length), median_sl, test$Sepal.Length)


cond1 = train %>% filter(Sepal.Width <= 10)
max_sw = cond1$Sepal.Width %>% max()
print(max_sw)

train$Sepal.Width = ifelse(train$Sepal.Width > 10, max_sw, train$Sepal.Width)
print(train %>% summary() )

df = train     # 데이터 복사
set.seed(2024) # 랜덤시드고정
idx <- createDataPartition(train$Species, p = 0.8, list = F)
train = df[idx, ]
val = df[-idx, ]

set.seed(2024)
model = randomForest(Species ~ ., data = train)
print(model)
print(summary(model))

x_val = val %>% select(-Species)
y_pred = predict(model, x_val)
print(y_pred %>% head())

cm = caret::confusionMatrix(y_pred, val$Species, positive = '2') # (예측값, 실제값)
print(cm)  # 기본 : 1         positive1 : Accuracy 1   2: 
print(cm$byClass) # 기본:1          positive1 : F1 1.0000000     2 :

y_prob = predict(model, newdata = x_val, type = 'prob')
AUC = auc(actual = val$Species, predicted = y_prob[,2])
print(AUC)