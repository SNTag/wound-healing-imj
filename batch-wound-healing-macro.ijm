input = getDirectory("Input Directory");
output = getDirectory("Output Directory");

//setBatchMode(true);
list = getFileList(input);
for (i = 0; i < list.length; i++) {
    action(input, output, list[i]);
}

run("Install...", "install=[D:/Dropbox/work/imaging/Fiji macro/MRI_Wound_Healing_Tool.ijm]");	











//
//  Start of program
//

function action(input, output, image) {
    setBatchMode(true);


// To Run the wound healing measuring macro 
IJ.log("Check if running");

macro 'Measure Wound Healing Action Tool - C000T4b12m' {
	run("Select None");
	getPixelSize(unit, pixelWidth, pixelHeight);
	run("Duplicate...", "duplicate");
    setForegroundColor(0, 0, 0);
    setBackgroundColor(255, 255, 255);
    roiManager("reset")
    roiManager("Associate", "true");
    if (method=="variance") 
        thresholdVariance();
    else 
        thresholdFindEdges();
    run("Convert to Mask", " black");
    resetThreshold();
    run("Invert", "stack");
    for (i=0; i<radiusOpen; i++) {
        run("Dilate", "stack");
    }
    for (i=0; i<radiusOpen; i++) {
        run("Erode", "stack");
    }
    run("Select All");
    run("Enlarge...", "enlarge=-" + radiusOpen + " pixel");
    run("Invert", "stack");
    run("Analyze Particles...", "size="+minSize+"-Infinity circularity=0.00-1.00 show=Nothing add stack");
    close();
    run("Clear Results");
    if (measureInPixelUnits)
    		run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel");
    roiManager("Measure"); 
    roiManager("Show None");
	roiManager("Show All");
}


// To save results
	selectWindow("Results");
	// saveAs("Results",  output + yourFileName + ".csv"); 
	// saveAs("Results")
	selectWindow("ROI Manager")


// To close previously opened windows.
    selectWindow("ROI Manager");
    run("Close");
    selectWindow("Results");
    run("Close");
}