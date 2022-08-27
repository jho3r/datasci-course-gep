# Instalando paquete
# if(!require(installr)) { install.packages("installr"); }
# install.R()

# Accede a la base de datos de la organizacion mundial del trabajo con Rilostat
install.packages(
    "Rilostat",
    "C:/Users/jhoer/AppData/Local/Temp/RtmpsvNsLY/downloaded_packages"
)

# install.packages('devtools')

library("Rilostat")

toc <- get_ilostat_toc()
View(toc)

INFLA <- get_ilostat("CPI_ACPI_COI_RT_A")
DESEMPLEO <- get_ilostat("SDG_0852_SEX_AGE_RT_A")
INFOR <- get_ilostat("EMP_NIFL_SEX_RT_A")
TEMP <- get_ilostat("EES_XTMP_SEX_RT_A")

# Ahora para el banco mundial
install.packages("wbstats")
library("wbstats")

new_cache <- wb_cache()

vars_infor <- wb_search(pattern="Taxes", cache = new_cache)

TAXES <- wb_data(indicator = "GC.TAX.YPKG.ZS")

# datos de gdp
install.packages("pwt10")
library(pwt10)
data("pwt10.0")
View(pwt10.0)

GDP_CAP <- subset(
  pwt10.0,
  select = c("country", "isocode", "year", "rgdpe", "pop")
)

View(INFLA)
unique(INFLA$classif1)

INFLA <- INFLA[(INFLA$classif1=="COI_COICOP_CP01"),]
colnames(INFLA)

INFLA <- subset(INFLA, select=c(ref_area, time, obs_value))
colnames(INFLA)
names(INFLA)
View(INFLA)

names(INFLA)[names(INFLA) == "obs_value"] <- "V_IPC"
names(INFLA)[names(INFLA) == "ref_area"] <- "iso3c"
View(INFLA)

DESEMPLEO <- DESEMPLEO[(DESEMPLEO$sex=="SEX_T" & DESEMPLEO$classif1=="AGE_YTHADULT_YGE15"),]

DESEMPLEO<- subset(DESEMPLEO, select = c(ref_area, time, obs_value))

names(DESEMPLEO)[names(DESEMPLEO)=="obs_value"] <- "T_DESEM"
names(DESEMPLEO)[names(DESEMPLEO)=="ref_area"] <- "iso3c"

##INFOR

INFOR <- INFOR[(INFOR$sex=="SEX_T"),]

INFOR<- subset(INFOR, select=c(ref_area, time, obs_value))

names(INFOR)[names(INFOR) == "obs_value"] <- "INFOR"

names(INFOR)[names(INFOR) == "ref_area"] <- "iso3c"

#TEMP

TEMP <- TEMP[(TEMP$sex=="SEX_T"),]

TEMP<- subset(TEMP, select=c(ref_area, time, obs_value))

names(TEMP)[names(TEMP) == "obs_value"] <- "TEMP"

names(TEMP)[names(TEMP) == "ref_area"] <- "iso3c"

XXX <- 1
rm(XXX)

##### Datos del banco mundial####

View(TAXES)

names(TAXES)

TAXES <- subset(TAXES, 
                select=c(iso3c, date, GC.TAX.YPKG.ZS))


names(TAXES)[names(TAXES) == "GC.TAX.YPKG.ZS"] <- "TIP"


names(TAXES)[names(TAXES) == "date"] <- "time"



#### Procesando datos de Penn World####

View(GDP_CAP)

colnames(GDP_CAP)

names(GDP_CAP)[names(GDP_CAP) == "isocode"] <- "iso3c"


names(GDP_CAP)[names(GDP_CAP) == "year"] <- "time"

#per capita:
GDP_CAP$gdp_cap_e <- GDP_CAP$rgdpe / GDP_CAP$pop

GDP_CAP <- subset(GDP_CAP, select = c(iso3c, time, gdp_cap_e))


#Ahora unimos todas las bases
BASE_TOTAL <- Reduce(function(...) merge(..., by=c("iso3c","time")), 
                     list(GDP_CAP,DESEMPLEO,TAXES,INFLA))

INFLA_DES <- merge(DESEMPLEO, INFLA, by=c("iso3c","time"))

INFOR_TEMP <- merge(INFOR, TEMP, by=c("iso3c","time"))


# Nuevos paquetes para graficar

install.packages("ggplot2")
install.packages("ggpmisc")
library(ggplot2)
library(ggpmisc)

my.formula <- y ~ x

GDP_VS_TD <- ggplot(subset(BASE_TOTAL,time==2014), aes(x= gdp_cap_e, y=T_DESEM)) + 
  geom_smooth(method="lm") +
  stat_poly_eq(formula = my.formula,
               eq.with.lhs = "italic(hat(y))~`=`~",
               aes(label = paste(..eq.label.., ..rr.label.., sep = "~~~")), 
               parse = TRUE, hjust=0,vjust=21)+
  labs(subtitle="log(PIB per cápita) vs Tasa de desempleo (%)", 
       y="Tasa de desempleo (%)", 
       x="log(PIB per cápita)") + theme(legend.position="none") + 
  geom_text(aes(label=iso3c),hjust=0,vjust=0)


plot(GDP_VS_TD)

##INFLACION VS DESEMPLEO


INFLA_VS_TD <- ggplot(subset(INFLA_DES,time==2014), aes(x= V_IPC, y=T_DESEM)) + 
  geom_smooth(method="lm") +
  stat_poly_eq(formula = my.formula,
               eq.with.lhs = "italic(hat(y))~`=`~",
               aes(label = paste(..eq.label.., ..rr.label.., sep = "~~~")), 
               parse = TRUE, hjust=0,vjust=21)+
  labs(subtitle="Inflación vs Tasa de desempleo (%)", 
       y="Tasa de desempleo (%)", 
       x="Inflación") + theme(legend.position="none") + 
  geom_text(aes(label=iso3c),hjust=0,vjust=0)

##r
plot(INFLA_VS_TD)

### Total tax rate (% of profit) vs PIB
colnames(BASE_TOTAL)


GDP_VS_IMPU <- ggplot(subset(BASE_TOTAL,time==2014), aes(x= log(gdp_cap_e), y=TIP)) + 
  geom_smooth(method="lm") +
  stat_poly_eq(formula = my.formula,
               eq.with.lhs = "italic(hat(y))~`=`~",
               aes(label = paste(..eq.label.., ..rr.label.., sep = "~~~")), 
               parse = TRUE, hjust=0,vjust=21)+
  
  labs(subtitle="log(PIB per cápita) vs Impuesto a los beneficios (%)", 
       y="Impuesto a los beneficios (%)", 
       x="log(PIB per cápita)") + theme(legend.position="none") + 
  geom_text(aes(label=iso3c),hjust=0,vjust=0)


plot(GDP_VS_IMPU)


