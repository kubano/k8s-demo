FROM mcr.microsoft.com/dotnet/core/aspnet:2.2 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build
WORKDIR /src
COPY ["k8s-demo.csproj", "./"]

RUN dotnet restore "./k8s-demo.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "k8s-demo.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "k8s-demo.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "k8s-demo.dll"]