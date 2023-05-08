%dw 2.0
output application/json
//here i need to use the splitBy function and write a custom function in DataWeave to split the "fullName" field of each object in the array into two fields called "firstName" and "lastName" to get my expected output
fun nameSplit(name ) = name splitBy  " "
---
//here i  use the map function to loop over the input array of objects and perform operations on each object to return an array.
payload map {
    "firstName": nameSplit($.fullName)[0],
    "lastName": nameSplit($.fullName)[1],
    //Here I used  valuesOf function extracts an array of values from an object's key-value pairs and returns an array with an index value that can be used to filter only the values that are necessary.
    //Here need to convert it to a single string. To do so, we can use the reduction function to concatenate the strings of the array (address) into a single string. "$$" refers to the accumulator, and "$" refers to the array element. "++" operator is used for concatenation 
    "AddrWithValuesOf" : valuesOf($)[3 to 6] reduce ($$ ++ "," ++ $),
    // here i used pluck function instead of using valuesOf pluck function to extract values or keys from an object's key-value pairs and return an array of keys or values
    "AddrWithPluck" : ($ pluck (V,K) -> (V)) [ 3 to 6] reduce ($$ ++ "," ++ $),
    //This is the final step in achieving the desired output. We need to format data in this stage, to format "miles" as a number with two decimals, use the following syntax: { format : "0.00" }
     "miles" : $.miles as String   { format : "0.00" } as Number,
     //To format "DateofJoin" into the desired date format, we must first declare the existing date format, which is { format: 'yyyy-MM-dd' } followed by the desired date { format : "dd-MMM-yyyy" }
     "DateofJoin": $.joinedDate as Date {format: 'yyyy-MM-dd'} as String { format : "dd-MMM-yyyy" } 
}