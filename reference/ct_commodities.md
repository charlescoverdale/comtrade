# Search Commodity Codes

Search the HS (Harmonized System) commodity classification for codes
matching a keyword or code pattern. Uses a built-in table of 96
two-digit HS chapters with descriptions.

## Usage

``` r
ct_commodities(query = NULL, level = NULL)
```

## Arguments

- query:

  Character. Search term (matched against commodity descriptions) or a
  partial HS code (e.g., `"27"` for mineral fuels). Default `NULL`
  (return all).

- level:

  Integer. HS digit level to return. Currently only level 2 is available
  from the built-in table. Default `NULL` (all levels).

## Value

A data.frame with columns:

- code:

  HS 2-digit chapter code

- description:

  Chapter description

- level:

  Digit level (always 2 for built-in table)

- parent:

  Parent code (NA for 2-digit chapters)

## Examples

``` r
# Search for petroleum-related codes
ct_commodities("petroleum")
#> [1] code        description level       parent     
#> <0 rows> (or 0-length row.names)

# List all 2-digit HS chapters
ct_commodities()
#>    code                  description level parent
#> 1    01                 Live animals     2   <NA>
#> 2    02                         Meat     2   <NA>
#> 3    03                         Fish     2   <NA>
#> 4    04           Dairy, eggs, honey     2   <NA>
#> 5    05        Other animal products     2   <NA>
#> 6    06           Live trees, plants     2   <NA>
#> 7    07                   Vegetables     2   <NA>
#> 8    08                  Fruit, nuts     2   <NA>
#> 9    09          Coffee, tea, spices     2   <NA>
#> 10   10                      Cereals     2   <NA>
#> 11   11             Milling products     2   <NA>
#> 12   12                    Oil seeds     2   <NA>
#> 13   13                 Gums, resins     2   <NA>
#> 14   14           Vegetable plaiting     2   <NA>
#> 15   15                   Fats, oils     2   <NA>
#> 16   16            Meat preparations     2   <NA>
#> 17   17                       Sugars     2   <NA>
#> 18   18                        Cocoa     2   <NA>
#> 19   19          Cereal preparations     2   <NA>
#> 20   20       Vegetable preparations     2   <NA>
#> 21   21      Misc. food preparations     2   <NA>
#> 22   22                    Beverages     2   <NA>
#> 23   23        Residues, animal feed     2   <NA>
#> 24   24                      Tobacco     2   <NA>
#> 25   25  Salt, sulphur, earth, stone     2   <NA>
#> 26   26              Ores, slag, ash     2   <NA>
#> 27   27          Mineral fuels, oils     2   <NA>
#> 28   28          Inorganic chemicals     2   <NA>
#> 29   29            Organic chemicals     2   <NA>
#> 30   30      Pharmaceutical products     2   <NA>
#> 31   31                  Fertilisers     2   <NA>
#> 32   32     Tanning, dyeing extracts     2   <NA>
#> 33   33    Essential oils, cosmetics     2   <NA>
#> 34   34                    Soap, wax     2   <NA>
#> 35   35           Albuminoids, glues     2   <NA>
#> 36   36                   Explosives     2   <NA>
#> 37   37           Photographic goods     2   <NA>
#> 38   38      Misc. chemical products     2   <NA>
#> 39   39                     Plastics     2   <NA>
#> 40   40                       Rubber     2   <NA>
#> 41   41           Raw hides, leather     2   <NA>
#> 42   42             Leather articles     2   <NA>
#> 43   43                     Furskins     2   <NA>
#> 44   44                         Wood     2   <NA>
#> 45   45                         Cork     2   <NA>
#> 46   46              Straw, plaiting     2   <NA>
#> 47   47                    Wood pulp     2   <NA>
#> 48   48                        Paper     2   <NA>
#> 49   49            Printed materials     2   <NA>
#> 50   50                         Silk     2   <NA>
#> 51   51                         Wool     2   <NA>
#> 52   52                       Cotton     2   <NA>
#> 53   53       Other vegetable fibres     2   <NA>
#> 54   54           Man-made filaments     2   <NA>
#> 55   55       Man-made staple fibres     2   <NA>
#> 56   56                Wadding, felt     2   <NA>
#> 57   57                      Carpets     2   <NA>
#> 58   58        Special woven fabrics     2   <NA>
#> 59   59         Impregnated textiles     2   <NA>
#> 60   60              Knitted fabrics     2   <NA>
#> 61   61              Knitted apparel     2   <NA>
#> 62   62                Woven apparel     2   <NA>
#> 63   63       Other textile articles     2   <NA>
#> 64   64                     Footwear     2   <NA>
#> 65   65                     Headgear     2   <NA>
#> 66   66                    Umbrellas     2   <NA>
#> 67   67            Prepared feathers     2   <NA>
#> 68   68                Stone, cement     2   <NA>
#> 69   69                     Ceramics     2   <NA>
#> 70   70                        Glass     2   <NA>
#> 71   71      Precious stones, metals     2   <NA>
#> 72   72               Iron and steel     2   <NA>
#> 73   73          Iron/steel articles     2   <NA>
#> 74   74                       Copper     2   <NA>
#> 75   75                       Nickel     2   <NA>
#> 76   76                    Aluminium     2   <NA>
#> 77   78                         Lead     2   <NA>
#> 78   79                         Zinc     2   <NA>
#> 79   80                          Tin     2   <NA>
#> 80   81            Other base metals     2   <NA>
#> 81   82                        Tools     2   <NA>
#> 82   83    Misc. base metal articles     2   <NA>
#> 83   84                    Machinery     2   <NA>
#> 84   85         Electrical equipment     2   <NA>
#> 85   86                      Railway     2   <NA>
#> 86   87                     Vehicles     2   <NA>
#> 87   88                     Aircraft     2   <NA>
#> 88   89                        Ships     2   <NA>
#> 89   90 Optical, medical instruments     2   <NA>
#> 90   91                       Clocks     2   <NA>
#> 91   92          Musical instruments     2   <NA>
#> 92   93                         Arms     2   <NA>
#> 93   94                    Furniture     2   <NA>
#> 94   95                         Toys     2   <NA>
#> 95   96           Misc. manufactured     2   <NA>
#> 96   97                Art, antiques     2   <NA>

# Find codes starting with "27" (mineral fuels)
ct_commodities("27")
#>   code         description level parent
#> 1   27 Mineral fuels, oils     2   <NA>
```
