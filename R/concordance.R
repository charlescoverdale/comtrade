#' Convert Between Trade Classifications
#'
#' Convert commodity codes between HS (Harmonized System), SITC, and BEC
#' classifications. Uses a built-in concordance table covering the most
#' common 2-digit HS chapters mapped to SITC sections and BEC categories.
#'
#' For detailed 4/6-digit concordances, see the `concordance` R package
#' on CRAN.
#'
#' @param code Character. The commodity code(s) to convert.
#' @param from Character. Source classification: `"HS"`, `"SITC"`, or `"BEC"`.
#' @param to Character. Target classification: `"HS"`, `"SITC"`, or `"BEC"`.
#'
#' @return A data.frame with columns: from_code, from_desc, to_code, to_desc.
#'
#' @export
#'
#' @examples
#' # Convert HS chapter 27 (mineral fuels) to SITC
#' ct_concordance("27", from = "HS", to = "SITC")
#'
#' # Convert SITC section 0 (food) to HS
#' ct_concordance("0", from = "SITC", to = "HS")
ct_concordance <- function(code, from = "HS", to = "SITC") {
  from <- toupper(from)
  to <- toupper(to)
  valid <- c("HS", "SITC", "BEC")

  if (!from %in% valid) cli::cli_abort("{.arg from} must be one of: {.val {valid}}.")
  if (!to %in% valid) cli::cli_abort("{.arg to} must be one of: {.val {valid}}.")
  if (from == to) cli::cli_abort("{.arg from} and {.arg to} must be different.")

  tbl <- ct_concordance_table()
  from_col <- paste0(tolower(from), "_code")
  to_col <- paste0(tolower(to), "_code")
  from_desc_col <- paste0(tolower(from), "_desc")
  to_desc_col <- paste0(tolower(to), "_desc")

  matches <- tbl[tbl[[from_col]] %in% code, ]

  if (nrow(matches) == 0L) {
    cli::cli_warn("No concordance found for {.val {code}} in {from}.")
    return(data.frame(
      from_code = character(0), from_desc = character(0),
      to_code = character(0), to_desc = character(0),
      stringsAsFactors = FALSE
    ))
  }

  out <- data.frame(
    from_code = matches[[from_col]],
    from_desc = matches[[from_desc_col]],
    to_code = matches[[to_col]],
    to_desc = matches[[to_desc_col]],
    stringsAsFactors = FALSE
  )
  out <- unique(out)
  rownames(out) <- NULL
  out
}


#' Built-in concordance table (HS 2-digit to SITC section to BEC)
#'
#' 96 rows mapping each 2-digit HS chapter to a SITC section (0-9) and
#' BEC category (1-6). Built from the UN official correspondence tables.
#' @noRd
ct_concordance_table <- function() {
  # Build row by row to avoid length mismatches
  rows <- list(
    # HS, HS desc, SITC, SITC desc, BEC, BEC desc
    c("01","Live animals","0","Food and live animals","1","Food and beverages"),
    c("02","Meat","0","Food and live animals","1","Food and beverages"),
    c("03","Fish","0","Food and live animals","1","Food and beverages"),
    c("04","Dairy, eggs, honey","0","Food and live animals","1","Food and beverages"),
    c("05","Other animal products","0","Food and live animals","1","Food and beverages"),
    c("06","Live trees, plants","2","Crude materials","1","Food and beverages"),
    c("07","Vegetables","0","Food and live animals","1","Food and beverages"),
    c("08","Fruit, nuts","0","Food and live animals","1","Food and beverages"),
    c("09","Coffee, tea, spices","0","Food and live animals","1","Food and beverages"),
    c("10","Cereals","0","Food and live animals","1","Food and beverages"),
    c("11","Milling products","0","Food and live animals","1","Food and beverages"),
    c("12","Oil seeds","2","Crude materials","1","Food and beverages"),
    c("13","Gums, resins","2","Crude materials","1","Food and beverages"),
    c("14","Vegetable plaiting","2","Crude materials","1","Food and beverages"),
    c("15","Fats, oils","4","Animal and vegetable oils","1","Food and beverages"),
    c("16","Meat preparations","0","Food and live animals","1","Food and beverages"),
    c("17","Sugars","0","Food and live animals","1","Food and beverages"),
    c("18","Cocoa","0","Food and live animals","1","Food and beverages"),
    c("19","Cereal preparations","0","Food and live animals","1","Food and beverages"),
    c("20","Vegetable preparations","0","Food and live animals","1","Food and beverages"),
    c("21","Misc. food preparations","0","Food and live animals","1","Food and beverages"),
    c("22","Beverages","1","Beverages and tobacco","1","Food and beverages"),
    c("23","Residues, animal feed","0","Food and live animals","1","Food and beverages"),
    c("24","Tobacco","1","Beverages and tobacco","1","Food and beverages"),
    c("25","Salt, sulphur, earth, stone","2","Crude materials","2","Industrial supplies"),
    c("26","Ores, slag, ash","2","Crude materials","2","Industrial supplies"),
    c("27","Mineral fuels, oils","3","Mineral fuels","3","Fuels and lubricants"),
    c("28","Inorganic chemicals","5","Chemicals","2","Industrial supplies"),
    c("29","Organic chemicals","5","Chemicals","2","Industrial supplies"),
    c("30","Pharmaceutical products","5","Chemicals","5","Consumer goods"),
    c("31","Fertilisers","5","Chemicals","2","Industrial supplies"),
    c("32","Tanning, dyeing extracts","5","Chemicals","2","Industrial supplies"),
    c("33","Essential oils, cosmetics","5","Chemicals","5","Consumer goods"),
    c("34","Soap, wax","5","Chemicals","5","Consumer goods"),
    c("35","Albuminoids, glues","5","Chemicals","2","Industrial supplies"),
    c("36","Explosives","5","Chemicals","2","Industrial supplies"),
    c("37","Photographic goods","5","Chemicals","2","Industrial supplies"),
    c("38","Misc. chemical products","5","Chemicals","2","Industrial supplies"),
    c("39","Plastics","5","Chemicals","2","Industrial supplies"),
    c("40","Rubber","2","Crude materials","2","Industrial supplies"),
    c("41","Raw hides, leather","2","Crude materials","2","Industrial supplies"),
    c("42","Leather articles","8","Misc. manufactured","5","Consumer goods"),
    c("43","Furskins","2","Crude materials","2","Industrial supplies"),
    c("44","Wood","6","Manufactured goods","2","Industrial supplies"),
    c("45","Cork","6","Manufactured goods","2","Industrial supplies"),
    c("46","Straw, plaiting","6","Manufactured goods","2","Industrial supplies"),
    c("47","Wood pulp","2","Crude materials","2","Industrial supplies"),
    c("48","Paper","6","Manufactured goods","2","Industrial supplies"),
    c("49","Printed materials","8","Misc. manufactured","5","Consumer goods"),
    c("50","Silk","6","Manufactured goods","2","Industrial supplies"),
    c("51","Wool","6","Manufactured goods","2","Industrial supplies"),
    c("52","Cotton","6","Manufactured goods","2","Industrial supplies"),
    c("53","Other vegetable fibres","6","Manufactured goods","2","Industrial supplies"),
    c("54","Man-made filaments","6","Manufactured goods","2","Industrial supplies"),
    c("55","Man-made staple fibres","6","Manufactured goods","2","Industrial supplies"),
    c("56","Wadding, felt","6","Manufactured goods","2","Industrial supplies"),
    c("57","Carpets","6","Manufactured goods","2","Industrial supplies"),
    c("58","Special woven fabrics","6","Manufactured goods","2","Industrial supplies"),
    c("59","Impregnated textiles","6","Manufactured goods","2","Industrial supplies"),
    c("60","Knitted fabrics","6","Manufactured goods","2","Industrial supplies"),
    c("61","Knitted apparel","8","Misc. manufactured","5","Consumer goods"),
    c("62","Woven apparel","8","Misc. manufactured","5","Consumer goods"),
    c("63","Other textile articles","6","Manufactured goods","2","Industrial supplies"),
    c("64","Footwear","8","Misc. manufactured","5","Consumer goods"),
    c("65","Headgear","8","Misc. manufactured","5","Consumer goods"),
    c("66","Umbrellas","8","Misc. manufactured","5","Consumer goods"),
    c("67","Prepared feathers","2","Crude materials","2","Industrial supplies"),
    c("68","Stone, cement","6","Manufactured goods","2","Industrial supplies"),
    c("69","Ceramics","6","Manufactured goods","2","Industrial supplies"),
    c("70","Glass","6","Manufactured goods","2","Industrial supplies"),
    c("71","Precious stones, metals","6","Manufactured goods","2","Industrial supplies"),
    c("72","Iron and steel","6","Manufactured goods","2","Industrial supplies"),
    c("73","Iron/steel articles","6","Manufactured goods","2","Industrial supplies"),
    c("74","Copper","6","Manufactured goods","2","Industrial supplies"),
    c("75","Nickel","6","Manufactured goods","2","Industrial supplies"),
    c("76","Aluminium","6","Manufactured goods","2","Industrial supplies"),
    c("78","Lead","6","Manufactured goods","2","Industrial supplies"),
    c("79","Zinc","6","Manufactured goods","2","Industrial supplies"),
    c("80","Tin","6","Manufactured goods","2","Industrial supplies"),
    c("81","Other base metals","6","Manufactured goods","2","Industrial supplies"),
    c("82","Tools","6","Manufactured goods","2","Industrial supplies"),
    c("83","Misc. base metal articles","6","Manufactured goods","2","Industrial supplies"),
    c("84","Machinery","7","Machinery and transport","4","Capital goods"),
    c("85","Electrical equipment","7","Machinery and transport","4","Capital goods"),
    c("86","Railway","7","Machinery and transport","4","Capital goods"),
    c("87","Vehicles","7","Machinery and transport","4","Capital goods"),
    c("88","Aircraft","7","Machinery and transport","4","Capital goods"),
    c("89","Ships","7","Machinery and transport","4","Capital goods"),
    c("90","Optical, medical instruments","8","Misc. manufactured","4","Capital goods"),
    c("91","Clocks","8","Misc. manufactured","5","Consumer goods"),
    c("92","Musical instruments","8","Misc. manufactured","5","Consumer goods"),
    c("93","Arms","9","Commodities n.e.s.","6","Other"),
    c("94","Furniture","8","Misc. manufactured","5","Consumer goods"),
    c("95","Toys","8","Misc. manufactured","5","Consumer goods"),
    c("96","Misc. manufactured","8","Misc. manufactured","5","Consumer goods"),
    c("97","Art, antiques","9","Commodities n.e.s.","6","Other")
  )

  mat <- do.call(rbind, rows)
  data.frame(
    hs_code = mat[, 1],
    hs_desc = mat[, 2],
    sitc_code = mat[, 3],
    sitc_desc = mat[, 4],
    bec_code = mat[, 5],
    bec_desc = mat[, 6],
    stringsAsFactors = FALSE
  )
}
