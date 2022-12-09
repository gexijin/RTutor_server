library(shiny)
###################################################################
# UI
###################################################################

ui <- fluidPage(
  titlePanel("RTutor - Do statistics in English"),
  windowTitle = "RTutor",
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
        # Application title

      p(HTML("<div align=\"right\"> <A HREF=\"javascript:history.go(0)\">Reset</A></div>")),
      fluidRow(
        column(
          width = 4,
          uiOutput("demo_data_ui")
        ),
        column(
          width = 8,
          uiOutput("data_upload_ui")
        )
      ),
      fluidRow(
        column(
          width = 8,
          uiOutput("prompt_ui")
        )
      ),

      tags$style(type = "text/css", "textarea {width:100%}"),
      tags$textarea(
        id = "input_text",
        placeholder = NULL,
        rows = 8, ""
      ),
      actionButton("submit_button", strong("Submit")),
      tags$head(tags$style(
        "#submit_button{font-size: 16px;color: red}"
      )),
      tippy::tippy_this(
        "submit_button",
        "ChatGPT can return different results for the same request.",
        theme = "light-border"
      ),
      br(), br(),
      fluidRow(
        column(
          width = 4,
          downloadButton(
            outputId = "report",
            label = "Report"
          ),
          tippy::tippy_this(
            "report",
            "Download a HTML report for this session.",
            theme = "light-border"
          )
        ),
        column(
          width = 8,
          downloadButton(
            outputId = "Rmd_source",
            label = "RMarkdown"
          ),
          tippy::tippy_this(
            "Rmd_source",
            "Download a R Markdown source file.",
            theme = "light-border"
          )
        )
      ),
      br(), br(),
      textOutput("usage"),
      textOutput("total_cost"),
      textInput("api_key", label = h3("Your OpenAI API Key:"), value = "sk-...nOiN"),
    ),

    # Show a plot of the generated distribution
    mainPanel(

      tabsetPanel(
        id = "tabs",
        tabPanel(
          title = "Main",
          value = "Main",
          h4("AI generated R code:"),
          verbatimTextOutput("openAI"),
          br(), br(),
          h4("Results:"),
          uiOutput("results_ui"),
          br(), br(),
          tableOutput("data_table")
        ),

        tabPanel(
          title = "Log",
          value = "Log",
          verbatimTextOutput("rmd_chuck_output")
        ),

        tabPanel(
          title = "About",
          value = "About",
          h5("RTutor uses ",
            a(
              "OpenAI's",
              href = "https://openai.com/",
              target = "_blank"
            ),
            " powerful ",
            language_model,
            "language model",
            " to translate natural language into R code, which is then excuted.",
            "You can request your analysis,
            just like asking a real person.",
            "Upload a data file (CSV, TSV/tab-delimited text files, and Excel) 
            and just analyze it in plain English. 
            Your results can be downloaded as an HTML report in minutes!"
          ),
          h5("NO WARRANTY! Some of the scripts runs but are incorrect. 
          Please use the auto-generated code as a starting 
          point for further refinement and validation."),

          h5("OpenAI's models are accessed via API, which is not free. Please do not abuse it."),

          p(" Personal hobby project by",
            a(
              "Xijin Ge.",
               href = "https://twitter.com/StevenXGe",
               target = "_blank"
            ),
            " For feedback, please email",
            a(
              "gexijin@gmail.com.",
              href = "mailto:gexijin@gmail.com?Subject=RTutor"
            ),

            "Version 1.0 12/8/2022."
          ),
          uiOutput("session_info")
        )
      )
    )
  ),
  tags$head(includeHTML(("ga.html")))
)
