# Inicio de la intro
# R como calculadora

4+9

log(9)

9 > 8 # CTRL + ENTER

"A" > "B"

# PIDIENDO AYUDA

# R programming -> Post to the R mailing list or StackOverflow
# Data analysis/statistics --> CrossValidated

# algunas funciones importantes para pedir ayuda

rnorm

?rnorm

help.search("rnorm")

# para obtener argumentos

args("rnorm")

# papers especializados, ejemplo de package spacetime

# Ajustando directorio de trabajo

# Para saber cual es el directorio actual

getwd()

# Editando directorio

setwd("c:/users/jho3r/Desktop/Universidad/Especializacion Gestion/Codigos/aec")

# Comprobando cambio de directorio
# Este comando sirve para comprobar el directorio de trabajo

getwd()

# Tipos de objetos

# Numeros

# Guardamos y observamos como se guarda

# Nombre del objeto - operador de creacion (<-) - el objeto como

y <- 1

y

str(y)

# Ahora le decimos a R que necesitamos que 1 sea un entero

x <- 1L

x
y

str(x)
str(y)

# Numeros especiales 

1/0

1/Inf

# Valores NaN

0/0

# Formas de crear entradas
# vectores

x <- 1:10

# Para visualizar el objeto

x #Forma automatica

print(x) # Forma explicita


# vectores con c()

y <- c(1.2, 1.9)

y

y <- c(TRUE, FALSE)

y

y <- c(T,F)

y

y <- c("a", "b", "c", "y")

y

y <- c(2 + 0i, 2 + 5i)

y

# vectores con "vector()"

y <- vector("numeric", length = 10)

x <- c(3.4, "d") # convierte el 3.4 a string

# Cambiar el tipo de objeto de forma intencional

x <- 60:80

(x)
str(x)
class(x)

x <- as.character(x)

x

class(x)

x <- as.numeric(x)
x

# Matrices
matrix()

J <- matrix(nrow=5, ncol=5)

# una lista se crea con el comando list(objeto1, objeto2, objeto3)

x <- c(1, 4, 5, 6)
z <- c("j", "m", "l")
o <- FALSE

y <- list(x, z, o)
str(y)
y


# factor

x <- factor(c("Hombre", "Mujer", "Niño", "Niña")) # con factro se añaden niveles

x

table(x)
unclass(x)


# Missing values

z <- c(30,40,NA,50,10)
table(z)
z

is.na(z)
table(is.na(z))
is.nan(z)

# data frame
w <- data.frame(Sexo = c("Mujer", "Mujer", "Hombre", "Hombre"),
Estado = c("Empleada", "Desempleada", "Empleado", "Desempleado"))

w

View(w)
nrow(w)
ncol(w)

w <- data.frame(
    Sexo = c("Mujer", "Mujer", "Hombre", "Hombre", NA, NA),
    Estado = c("Empleada", "Desempleada", "Empleado", "Desempleado", "Desempleado", "Empleado"),
    Ingreso = c(1000000, 4500000, 1000000, 3500000, NA, NA)
)

View(w)

w

w$Ingreso

table(is.na(w))

str(w)

w$Ingreso

table(is.na(w$Ingreso))

levels(w$Sexo)
str(w$Sexo)
w$Sexo <- as.factor(w$Sexo) #Cambia el tipo de la columna
levels(w$Sexo)
str(w$Sexo)

names(w)

attributes(w)

w <- data.frame(
    Tipo_Publicidad = c("Folletos", "RedesSociales", "Folletos", "RedesSociales", "Folletos", "RedesSociales"),
    Ingreso = c(1000000, 4000000, 3000000, 4000000, 1500000, 4000000)
)

w

z <- lm(w$Ingreso ~ w$Tipo_Publicidad)

summary(z)

w$Tipo_Publicidad <- as.factor(w$Tipo_Publicidad)

z <- lm(w$Ingreso ~ w$Tipo_Publicidad) # lm(variabledependiente ~ idependiente)

summary(z)

w

# w[#filas, #columnas]

w[5,]
w[,2]
w[2,1]
