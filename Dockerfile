FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 5000
EXPOSE 443
ENV ASPNETCORE_URLS=http://*:5000

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["asp_docker.csproj", "./"]
RUN dotnet restore "asp_docker.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "asp_docker.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "asp_docker.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "asp_docker.dll"]
