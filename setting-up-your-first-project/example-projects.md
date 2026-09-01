## Example Projects

If you would like to explore some fully operational projects in detail, we've included several examples that cover a variety of use cases. Each of these use publicly available data and can be imported and worked through step by step to understand the full capabilities of the solution.

To make these projects more interactive, each project includes a **PowerPoint walkthrough designed to be used while you complete the project yourself**.

For the best experience, use two monitors:

- **Monitor #1 — Follow the walkthrough.** Keep the PowerPoint open for step-by-step instructions, explanations, and screenshots.
- **Monitor #2 — Complete the project.** Work through the same steps yourself in SAS Studio, SAS Event Stream Processing, or the other SAS applications used by the project.

Rather than simply reading about the completed project, you can **follow the instructions and build it yourself at your own pace**. The PowerPoint serves as your guide while you gain hands-on experience with the actual AutoML for IoT workflow.

![Interactive two-monitor training experience](images/interactive-training-experience.png)

The example projects demonstrate how AutoML for IoT can be applied to complete operational use cases.

### Solar Power Generation

This project queries information about a solar farm from a ClearBlade instance (an accelerated integration). Energy generation at the solar panel string level is aggregated up to other levels of the solar farm and ML models are deployed to model power generation at each level of the solar farm. Since the ClearBlade instance is internal to SAS, users will only be able to run through the historical replay of this example and will not set the project live.

Thumbnail 1        | Thumbnail 2        | Thumbnail 3 | Thumbnail 4 | Thumbnail 5 |
:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|
<img src="images/solarPowerGen1.png" width="500" alt="Overall Efficiency" /></a> | <img src="images/solarPowerGen2.png" width="500" alt="Efficiency Trends" /></a> | <img src="images/solarPowerGen3.png" width="500" alt="Relative Performance" /></a> | <img src="images/solarPowerGen4.png" width="500" alt="Model Detail" /></a> | <img src="images/solarPowerGen5.png" width="500" alt="Actual vs. Expected" /></a> |
 
Step-by-Step Guide         |
:-------------------------:|
<a href="ppt/SolarPowerGenProject.pptx"><img src="images/solarpowergen.png" width="500" alt="solarpowergen" /></a> |


### NYC Subway Train Monitoring 

This project queries information from publicly available APIs to gather information as to where each train is currently located. A digital twin of the entire subway system is maintained. Every minute, calculations are made to determine travel times between stations, wait times at each platform, and expected completion of the train's route given current conditions.
 
Thumbnail 1        | Thumbnail 2        | Thumbnail 3 | 
:-------------------------:|:-------------------------:|:-------------------------:|
<img src="images/subway1.png" width="500" alt="Main Dashboard" /></a> | <img src="images/subway2.png" width="500" alt="Train Level Detail Info" /></a> | <img src="images/subway3.png" width="500" alt="Delayed Trains" /></a> | 

Step-by-Step Guide         |
:-------------------------:|
<a href="ppt/NYCSubwayProject.pptx"><img src="images/nycsubway.png" width="500" alt="nycsubway" /></a> |


### Flood Prediction (North Carolina)

This project queries information from the USGS regarding river gauge heights and from a weather API to gather rain amounts and forecasts. Changes in gauge heights upstream and information about rainfall amounts are used to predict future gauge height levels up to 6 hours into the future, with ML models deployed individually for every river segment.
 
Thumbnail 1        | Thumbnail 2        | Thumbnail 3 | 
:-------------------------:|:-------------------------:|:-------------------------:|
<img src="images/floodPred1.png" width="500" alt="Main Dashboard" /></a> | <img src="images/floodPred2.png" width="500" alt="Prediction Detail" /></a> | <img src="images/floodPred3.png" width="500" alt="Rain Actual and Forecast" /></a> | 

Step-by-Step Guide         |
:-------------------------:|
<a href="ppt/FloodPredictionProject.pptx"><img src="images/floodprediction.png" width="500" alt="floodprediction" /></a> |


### Patient Sepsis Monitoring

This project monitors patients in a hospital who are at risk of sepsis. Regular updates are received about vitals signs and lab tests, and a patient risk probability is updated continuously using a machine learning model as new data arrives. This capability provides the hospital with a second set of eyes watching multiple inter-related metrics to ensure patient health and well-being is proactively managed.
 
Thumbnail 1        | Thumbnail 2        | Thumbnail 3 | 
:-------------------------:|:-------------------------:|:-------------------------:|
<img src="images/patientMonitoring1.png" width="500" alt="Patient Risk" /></a> | <img src="images/patientMonitoring2.png" width="500" alt="Lab Tests" /></a> | <img src="images/patientMonitoring3.png" width="500" alt="Vital Signs" /></a> | 

Step-by-Step Guide         |
:-------------------------:|
<a href="ppt/PatientMonitoringProject.pptx"><img src="images/patientmonitoring.png" width="500" alt="patientmonitoring" /></a> |


### Factory Production Monitoring

This project monitors a digital twin of a manufacturing line that produces sprockets. A furnace melts down and combines various metals and additives, pours the result into a mold for cooling, and then finishes each sprocket to smooth out any imperfections. A QA test is performed on the product three hours later to ensure the product is ready for sale. In this example, two concurrent approaches are used to monitor production. First, each batch is tracked as it is produced - attributes about the process are stored as the product moves through the production line, and a probability is assigned using an ML model as to whether the batch is likely to meet quality standards. This provides advance notice as to whether the product is likely to fail and allows the factory to operate more proactively. In addition, a second approach is implemented which continually watches current metrics across the factory and deploys an ML model which answers the question "if you continue to run the production line with these settings, then the quality is likely to be THIS in 3-4 hours". This provides an even greater degree of visibility for the factory technicians.

Thumbnail 1        | Thumbnail 2        | Thumbnail 3 | Thumbnail 4 |
:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|
<img src="images/manufacturing1.png" width="500" alt="Continuous Quality Monitoring" /></a> | <img src="images/manufacturing2.png" width="500" alt="Continuous Quality Monitoring (with Quality Tests)" /></a> | <img src="images/manufacturing3.png" width="500" alt="BAtch-Level Detail" /></a> | <img src="images/manufacturing4.png" width="500" alt="Diagnostics" /></a> |
 
Step-by-Step Guide         |
:-------------------------:|
<a href="ppt/FactoryMonitoringProject.pptx"><img src="images/factorymonitoring.png" width="500" alt="factorymonitoring" /></a> |

[Back to Setting Up Your First Project](README.md)
