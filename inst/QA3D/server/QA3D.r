filelist3 <- reactiveValues(list=list())

observeEvent(input$clearFile3D, {
	fileInput('aligndata', 'Upload data set', accept=c("xyz"), multiple = TRUE)
})

output$resettableInput3D <- renderUI({
	input$clearFile3D
	input$uploadFormat
	fileInput('aligndata', 'Upload data set', accept=c("xyz"), multiple = TRUE)
})

output$contents <- renderUI({
	HTML(paste(""))
})
output$contents1 <- renderUI({
	HTML(paste(""))
})

observeEvent(input$aligndata$datapath, {
	file.copy(input$aligndata$datapath, input$aligndata$name)
	filelist3$list <- input.3d(input$aligndata$name) #imports 3D xyzrbg data
})

observeEvent(input$Process, {
	showModal(modalDialog(title = "Calculation has started...Window will update when finished.", easyClose = FALSE, footer = NULL))
	withProgress(message = 'Calculation has started', detail = '', value = 0, {       
		for (i in 1:10) {
			incProgress(1/10)
			Sys.sleep(0.05)
		}
	})

	if(input$ncorespc != julia_call("nprocs")) {
		print("Setting up Julia workers...")
		JuliaSetup(add_cores = input$ncorespc, source = TRUE, recall_libraries = TRUE)
		print("Finished.")
	}
	if(input$kmeans) {
		ll <- length(filelist3$list)
		for (i in 1:ll) {	
			filelist3$list[[i]] <- kmeans.3d(filelist3$list[[i]], cluster = input$vara)
		}
	}

	d1 <<- compare.3d(data = filelist3$list, sessiontempdir = sessiontemp, procedure = input$Procedure, iteration = input$iterations, cores = input$ncorespc)





	#Zip and download handler
	#direc <- d2[[1]]
	#setwd(sessiontemp)
	#setwd(direc)
	#files <- list.files(recursive = TRUE)
	#zip:::zipr(zipfile = paste(direc,'.zip',sep=''), files = files)
	#output$downloadData2 <- downloadHandler(
	#	filename = function() {
	#		paste("results.zip")
	#	},
	#	content = function(file) {
	#		setwd(direc)
	#		file.copy(paste(direc,'.zip',sep=''), file)  
	#	},
	#	contentType = "application/zip"
	#)
	removeModal()
	setwd(sessiontemp)
	gc() #clean up 
})