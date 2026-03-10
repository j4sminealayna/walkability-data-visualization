# author: Jasmine Saunders
# purpose: Final Project

library(readr)
library(dplyr)
library(ggplot2)
library(maps)


walk <- read_csv("EPA_SmartLocationDatabase_V3_Jan_2021_Final.csv") %>%
  mutate(STATEFP = sprintf("%02d", as.integer(STATEFP)))

state_xwalk <- tibble::tibble(
  STATEFP = c("01","02","04","05","06","08","09","10","11","12","13","15","16",
              "17","18","19","20","21","22","23","24","25","26","27","28",
              "29","30","31","32","33","34","35","36","37","38","39","40",
              "41","42","44","45","46","47","48","49","50","51","53","54",
              "55","56"),
  StAbbr = c("AL","AK","AZ","AR","CA","CO","CT","DE","DC","FL","GA","HI","ID",
             "IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS",
             "MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK",
             "OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV",
             "WI","WY")
)

walk <- walk %>%
  inner_join(state_xwalk, by = "STATEFP")

walk_small <- walk %>%
  select(GEOID20, STATEFP, StAbbr,
         NatWalkInd, TotPop,
         D2A_EPHHM, D2B_E8MIXA, D3B, D4A,
         D2A_Ranked, D2B_Ranked, D3B_Ranked, D4A_Ranked)

# Walkability categories
walk_small <- walk_small %>%
  mutate(
    walk_cat = cut(
      NatWalkInd,
      breaks = c(0, 5.75, 10.5, 15.25, 20),
      labels = c("Least walkable",
                 "Below average",
                 "Above average",
                 "Most walkable"),
      include.lowest = TRUE
    )
  )

state_walk <- walk_small %>%
  group_by(StAbbr, walk_cat) %>%
  summarise(pop = sum(TotPop, na.rm = TRUE), .groups = "drop") %>%
  group_by(StAbbr) %>%
  mutate(pct_pop = 100 * pop / sum(pop)) %>%
  ungroup()

state_mean <- walk_small %>%
  group_by(StAbbr) %>%
  summarise(
    mean_walk = weighted.mean(NatWalkInd, TotPop, na.rm = TRUE),
    .groups = "drop"
  )

region_df <- tibble::tibble(
  StAbbr = state.abb,
  region = state.region
)

walk_region <- walk_small %>%
  inner_join(region_df, by = "StAbbr")


# Plot 1: Map of average walkability by state
us_states <- map_data("state") %>%
  mutate(StAbbr = toupper(state.abb[match(region, tolower(state.name))]))

map_df <- us_states %>%
  left_join(state_mean, by = "StAbbr")


ggplot(map_df, aes(long, lat, group = group, fill = mean_walk)) +
  geom_polygon(color = "white", linewidth = 0.1) +
  coord_fixed(1.3) +
  scale_fill_gradientn(
    colours = c("#E5F9E7",  # very light green (low)
                "#74C476",  # medium green
                "#00512C"), # dark forest green (high)
    name = "Avg. Walkability Score"
  ) +
  labs(
    title = "Average Walkability Index by State",
    caption = "EPA Smart Location Database, National Walkability Index"
  ) +
  theme_void() +
  theme(
    legend.position = "right",
    plot.title = element_text(hjust = 0.5)
  )


# Plot 2: % of population in "Most" vs "Least" walkable neighborhoods (selected states)
selected_states <- c("FL", "NY", "CA", "TX", "GA", "WA", "IL", "MA")

state_walk_sel <- state_walk %>%
  filter(StAbbr %in% selected_states,
         walk_cat %in% c("Least walkable", "Most walkable"))

ggplot(state_walk_sel,
       aes(x = reorder(StAbbr, pct_pop),
           y = pct_pop,
           fill = walk_cat)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Who Lives in the Most vs Least Walkable Neighborhoods?",
    x = "State",
    y = "Percent of population",
    fill = "Walkability group"
  ) +
  theme_minimal()


# Plot 3: Distribution of walkability by region
ggplot(walk_region, aes(x = region, y = NatWalkInd)) +
  geom_boxplot(outlier.size = 0.4) +
  labs(
    title = "Distribution of Walkability Scores by U.S. Region",
    x = "Region",
    y = "National Walkability Index (1–20)"
  ) +
  theme_minimal()

