param (
    [string]$Version = "5.14.0"
)

# Download and parse metadata from font awesome repository
$Icons = Invoke-WebRequest https://raw.githubusercontent.com/FortAwesome/Font-Awesome/$Version/metadata/icons.json | ConvertFrom-Json
$IconsMetadata = @();

# Iterate icons and create our own metadata
foreach ($Icon in $Icons.PSObject.Properties) {
    foreach ($Style in $Icon.Value.styles) {
        $Metadata = @{
            Icon = $Icon.Value.label;
            CSS = "fa$($Style[0]) fa-$($Icon.Name)";
            SearchTerms = $Icon.Value.search.terms -Join " ";
        }

        $IconsMetadata += New-Object PSObject -Property $Metadata
    }
}

# Write metadata result to js-file
$IconsMetadataJSON = ConvertTo-Json $IconsMetadata -Compress
"const icons=$IconsMetadataJSON;" | Set-Content ..\src\icons-metadata.js