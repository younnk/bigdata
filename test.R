# https://www.transfermarkt.com/robot.txt  ??ũ???? ???ɿ? Ȯ??

library("tibble")
library("rvest")
url <- "https://www.transfermarkt.com/spieler-statistik/wertvollstespieler/marktwertetop"
web_page <- read_html(url)

player_name <- web_page |> 
  html_elements("#yw1 .inline-table a") |> 
  html_text()
# player_name
player_name <- player_name[player_name != ""]   # ?÷??̾? ?̸? ????????
head(player_name)

national <- web_page |>
  html_elements(".zentriert:nth-child(4)")
  
national <- national[-1]  #Nat, romove
html_children(national[6]) |> length()  #individual check

count_dup <- sapply(national,
                    \(x) length(html_children(x)))
which(count_dup == 3)   #value 3 indicates dup
which(count_dup == 3) |> length()

national <- sapply(national,
                   \(x) html_attr(html_children(x)[1], "alt"))  # alt ?? ?ǹ̰? ????...
head(national)
length(national)

# Ŭ?? ????????
club_name <- web_page |>   
  html_elements(".zentriert a img") |> 
  html_attr("alt")
head(club_name)

# ???????? ????????
player_age <- web_page |> 
  html_elements(".zentriert:nth-child(3)") |> 
  html_text()
player_age <- player_age[-1] |> as.integer()
head(player_age)

# ???? ?????? ????????
position <- web_page |> 
  html_elements(".inline-table tr+ tr td") |> 
  html_text()
head(position)


# value ????????
library(stringr)
market_value <- web_page |> 
  html_elements(".rechts a") |> 
  html_text()
market_value

market_value <- maket_value[!str_detect(market_value, "\\n")]
market_value

#Ư?????ڸ? ?????ϴ? ?ڵ??ΰ? ?????? ?????ϸ? ???? ?߻?
# market_value <- market_value |>
# str_extract("^\\d????[.]^\\d^\\d") |>
# as.numeric()

head(market_value)


# ???? ??ġ??
soccer_data <- tibble(
  name = player_name,
  age = player_age,
  position = position,
  nationality = national,
  club = club_name,
  market_value = market_value
  )

write.csv(soccer_data,
          file = "soccer2024.csv",
          row.names = FALSE,
          fileEncoding = "UTF-8")

soccer_data |> glimpse()
