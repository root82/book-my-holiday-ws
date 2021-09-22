%dw 2.0
output application/json
import dw::core::Periods

var departureDate = vars.postRequest.departureDate as Date{format: "yyyy/MM/dd"}
var bookingDate = vars.postRequest.bookingdate as Date{format: "yyyy/MM/dd"}
var vDate = Periods::between(departureDate,bookingDate)
var discount = (price,value,toCheck,percent) ->
                (if (value > toCheck)
                    ( (price * percent)/100)
                else 0)
var price = payload.price default 0
---
{
	departureTime: payload.departureTime,
	passengerName: vars.postRequest.passengerName,
	flightCode: payload.flightCode,
	passengerIdProof: vars.postRequest.passengerIdProof,
	flightId: payload.flightId as String,
	currency: payload.currency,
	departureDate: vars.postRequest.departureDate,
	bookingdate: vars.postRequest.bookingdate,
	seatsBooked: vars.postRequest.seatsBooked,
	pricePerSeat: 
		(price -
        	(discount(price,vDate.days,15,10)	// 10% discount for date
            	+ discount(price,vars.postRequest.seatsBooked,5,20))	// 20 % discount for seats
             )
}