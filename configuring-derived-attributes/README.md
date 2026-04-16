# Configuring Derived Attributes

In an ideal world, all information needed for your digital twin would broadcast as raw sensor data. However, typically this is not the case in practical applications. It is many times necessary to calculate additional metrics based on information available in your digital twin. For example, it may be important to know the value of a sensor from an hour ago, or the average reading over the past 30 minutes, or to aggregate information from connected assets, or just execute code.

Derived attributes allow you to add new calculated measures to your digital twin - and they are configured simply by answering straightforward questions. Each attribute is described in detail in their sections below, and they are grouped based on their function as shown below. 


**These attributes will become part of your digital twin and you can use them later in your analytical models or output them to datasets you design. As shown below, these new attributes will appear in your digital twin in blue.**

<img src="images/digitalTwinWithEnrichment.png" alt="digitalTwinWithEnrichment" />


Below is a list of the derived attributes that are built-in to AutoML for IoT currently...

* **Time-Focused Attributes**
    * lag - store the value from a prior period
    * delta - calculate the change in an attribute from one time to another
    * temporalAgg - calculate the average/sum/min/max of an attribute over time

* **Relationship-Focused Attributes**
    * relationalAgg - calculated the average/sum/min/max of an attribute across connected assets
    * countConn - obtain the number of parents or children for each asset
    * getConn - obtain a specific assetID of a parent or child asset

* **Retrieving Connected Asset IDs and Labels**
    * getAssetID - store the ID of a connected asset 
    * getAssetLabel - store the label of a connected asset 

* **User-Written SAS Code**
    * code - run customized SAS code that references one or multiple attributes from the digital twin

* **Advanced**
    * getValue - copy the value of an attributeID from one asset to another
    * searchEvents - search recent events for a specific value and return the last time observed


Each of these derived attributes is described in detail in the sections below. Click on a powerpoint to learn more about how they work and how to configure them to enrich your digital twin.

Note that many derived attributes allow you to reference other derived attributes - so you can easily define an attribute and then use that attribute in yet another calculation. For example, a lag variable allows you to pull a sensor's value from some time ago. You could pull the value from an hour ago - that would be a 'static' lag. Or you could instead reference another derived attribute and the lag would become 'dynamic'. This is especially useful for manufacturing applications where the line speed could vary throughout the day.


## Time-Focused Attributes

### lag 

The below powerpoint will walk you through how to configure a 'lag' derived attribute. This is used to retrieve the value of an attribute from some time ago.

Step-by-Step Guide         |  
:-------------------------:|
<a href="ppt/Configuring-Derived-Attributes-lag.pptx"><img src="images/lag.png" width="500" alt="lag" /></a> |


### delta 

The below powerpoint will walk you through how to configure a 'delta' derived attribute. This is used to compute the change in an attribute from one time period to another.

Step-by-Step Guide         |  
:-------------------------:|
<a href="ppt/Configuring-Derived-Attributes-delta.pptx"><img src="images/delta.png" width="500" alt="delta" /></a> |


### temporalAgg 

The below powerpoint will walk you through how to configure a 'temporalAgg' derived attribute. This is used to aggregate the value of an attribute over some time period (average, sum, min, max).

Step-by-Step Guide         |  
:-------------------------:|
<a href="ppt/Configuring-Derived-Attributes-temporalAgg.pptx"><img src="images/temporalAgg.png" width="500" alt="temporalAgg" /></a> |

<br>

## Relationship-Focused Attributes

### relationalAgg 

The below powerpoint will walk you through how to configure a 'relationalAgg' derived attribute. This is used to aggregate the value of an attribute across connected assets.

Step-by-Step Guide         | 
:-------------------------:|
<a href="ppt/Configuring-Derived-Attributes-relationalAgg.pptx"><img src="images/relationalAgg.png" width="500" alt="relationalAgg" /></a> |


### countConn 

The below powerpoint will walk you through how to configure a 'countConn' derived attribute. This is used to count the number of connections (parent or child) for an asset.

Step-by-Step Guide         |  
:-------------------------:|
<a href="ppt/Configuring-Derived-Attributes-countConn.pptx"><img src="images/countConn.png" width="500" alt="countConn" /></a> |


### getConn 

The below powerpoint will walk you through how to configure a 'getConn' derived attribute. This is used to obtain the assetID for a connected asset (parent or child).

Step-by-Step Guide         |  
:-------------------------:|
<a href="ppt/Configuring-Derived-Attributes-getConn.pptx"><img src="images/getConn.png" width="500" alt="getConn" /></a> |

<br>

## Retrieving Connected Asset IDs and Labels

### getAssetID 

The below powerpoint will walk you through how to configure a 'getAssetID' derived attribute. This is used to retrieve the ID of a connected asset.

Step-by-Step Guide         | 
:-------------------------:|
<a href="ppt/Configuring-Derived-Attributes-getAssetID.pptx"><img src="images/getAssetID.png" width="500" alt="getAssetID" /></a> |


### getAssetLabel 

The below powerpoint will walk you through how to configure a 'getAssetLabel' derived attribute. This is used to retrieve the label of a connected asset.

Step-by-Step Guide         | 
:-------------------------:|
<a href="ppt/Configuring-Derived-Attributes-getAssetLabel.pptx"><img src="images/getAssetLabel.png" width="500" alt="getAssetLabel" /></a> |

<br>

## User-Written SAS Code

### code

The below powerpoint will walk you through how to configure a 'code' derived attribute. This is used to execute user-written code to compute a new metric using one or more attributes from the digital twin.

Step-by-Step Guide         | 
:-------------------------:|
<a href="ppt/Configuring-Derived-Attributes-code.pptx"><img src="images/code.png" width="500" alt="code" /></a> |

<br>

## Advanced

### getValue 

The below powerpoint will walk you through how to configure a 'getValue' derived attribute. This is used to copy the value of an attribute from a connected asset. For example, for flood prediction, what is the river's height for an upstream river segment. Or for patient monitoring, a hospital bed may measure blood pressure, but we'd like to associate that with the patient once it is measured.

Step-by-Step Guide         |  
:-------------------------:|
<a href="ppt/Configuring-Derived-Attributes-getValue.pptx"><img src="images/getValue.png" width="500" alt="getValue" /></a> |


### searchEvents 

The below powerpoint will walk you through how to configure a 'searchEvents' derived attribute. This is used to search the individual updates/events for an attribute. This is unique in that most attributes utilize only the value that was current at the time the output record was generated - this attribute allows the user to actually search through all of the individual updates/events.

Step-by-Step Guide         |  
:-------------------------:|
<a href="ppt/Configuring-Derived-Attributes-searchEvents.pptx"><img src="images/searchEvents.png" width="500" alt="searchEvents" /></a> |


[![Back](../images/back.png 'Back')](../describing-your-digital-twin/README.md)   [![Home](../images/home.png 'Home')](../enablement-home/README.md)   [![Next](../images/next.png 'Next')](../designing-output-tables-and-models/README.md)
