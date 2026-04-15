/**
* This tests the BDD functionality in TestBox.
*/
component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		session.siteid='default';
	}

	function afterAll(){
		console( "Executed afterAll() at #now()#" );
	}

/*********************************** BDD SUITES ***********************************/

	function run(){
		describe("Testing Date Helper Functions", function() {

			beforeEach(function() {
				utility = application.serviceFactory.getBean('utility');
			});

			it(
				title="dateMin: Should return the earlier of two dates",
				body=function() {
					var date1 = createDate(2026, 1, 15);
					var date2 = createDate(2026, 1, 20);
					
					var result = utility.dateMin(date1, date2);
					
					expect(result).toBe(date1);
					expect(isDate(result)).toBeTrue();
				}
			);

			it(
				title="dateMin: Should return the earlier date when second is earlier",
				body=function() {
					var date1 = createDate(2026, 1, 20);
					var date2 = createDate(2026, 1, 15);
					
					var result = utility.dateMin(date1, date2);
					
					expect(result).toBe(date2);
					expect(isDate(result)).toBeTrue();
				}
			);

			it(
				title="dateMin: Should handle equal dates",
				body=function() {
					var date1 = createDate(2026, 1, 15);
					var date2 = createDate(2026, 1, 15);
					
					var result = utility.dateMin(date1, date2);
					
					expect(dateFormat(result, 'yyyy-mm-dd')).toBe(dateFormat(date1, 'yyyy-mm-dd'));
					expect(isDate(result)).toBeTrue();
				}
			);

			it(
				title="dateMax: Should return the later of two dates",
				body=function() {
					var date1 = createDate(2026, 1, 15);
					var date2 = createDate(2026, 1, 20);
					
					var result = utility.dateMax(date1, date2);
					
					expect(result).toBe(date2);
					expect(isDate(result)).toBeTrue();
				}
			);

			it(
				title="dateMax: Should return the later date when first is later",
				body=function() {
					var date1 = createDate(2026, 1, 20);
					var date2 = createDate(2026, 1, 15);
					
					var result = utility.dateMax(date1, date2);
					
					expect(result).toBe(date1);
					expect(isDate(result)).toBeTrue();
				}
			);

			it(
				title="dateMax: Should handle equal dates",
				body=function() {
					var date1 = createDate(2026, 1, 15);
					var date2 = createDate(2026, 1, 15);
					
					var result = utility.dateMax(date1, date2);
					
					expect(dateFormat(result, 'yyyy-mm-dd')).toBe(dateFormat(date1, 'yyyy-mm-dd'));
					expect(isDate(result)).toBeTrue();
				}
			);

			it(
				title="dateMin/dateMax: Should preserve date object type (not convert to numeric)",
				body=function() {
					var date1 = createDate(2026, 1, 15);
					var date2 = createDate(2026, 1, 20);
					
					var minResult = utility.dateMin(date1, date2);
					var maxResult = utility.dateMax(date1, date2);
					
					// Should be dates, not numbers
					expect(isDate(minResult)).toBeTrue();
					expect(isDate(maxResult)).toBeTrue();
					expect(isNumeric(minResult) AND NOT isDate(minResult)).toBeFalse();
					expect(isNumeric(maxResult) AND NOT isDate(maxResult)).toBeFalse();
				}
			);

			it(
				title="dateOnly: Should strip time component from datetime",
				body=function() {
					var datetime = createDateTime(2026, 1, 15, 14, 30, 45);
					var expected = createDate(2026, 1, 15);
					
					var result = utility.dateOnly(datetime);
					
					expect(dateFormat(result, 'yyyy-mm-dd')).toBe(dateFormat(expected, 'yyyy-mm-dd'));
					expect(hour(result)).toBe(0);
					expect(minute(result)).toBe(0);
					expect(second(result)).toBe(0);
				}
			);

			it(
				title="dateOnly: Should preserve date object when time is already zero",
				body=function() {
					var date = createDate(2026, 1, 15);
					
					var result = utility.dateOnly(date);
					
					expect(dateFormat(result, 'yyyy-mm-dd')).toBe(dateFormat(date, 'yyyy-mm-dd'));
					expect(isDate(result)).toBeTrue();
				}
			);

			it(
				title="dateOnly: Should return date object, not numeric (BoxLang compatibility)",
				body=function() {
					var datetime = createDateTime(2026, 1, 15, 23, 59, 59);
					
					var result = utility.dateOnly(datetime);
					
					// Should be a date, not a number (this is what Fix() would have returned)
					expect(isDate(result)).toBeTrue();
					expect(isNumeric(result) AND NOT isDate(result)).toBeFalse();
				}
			);

			it(
				title="dateOnly: Should handle now() correctly",
				body=function() {
					var currentTime = now();
					
					var result = utility.dateOnly(currentTime);
					
					expect(dateFormat(result, 'yyyy-mm-dd')).toBe(dateFormat(currentTime, 'yyyy-mm-dd'));
					expect(hour(result)).toBe(0);
					expect(minute(result)).toBe(0);
				}
			);

			it(
				title="dateArrayMin: Should return the earliest date from an array of dates",
				body=function() {
					var dates = [
						createDate(2026, 4, 15),
						createDate(2026, 4, 10),
						createDate(2026, 4, 20),
						createDate(2026, 4, 5)
					];
					var result = utility.dateArrayMin(dates);
					expect(isDate(result)).toBeTrue();
					expect(dateFormat(result, 'yyyy-mm-dd')).toBe('2026-04-05');
				}
			);

			it(
				title="dateArrayMin: Should return a date object (not a number)",
				body=function() {
					var dates = [
						createDate(2026, 4, 15),
						createDate(2026, 4, 10)
					];
					var result = utility.dateArrayMin(dates);
					expect(isDate(result)).toBeTrue();
					// Verify it can be used in date operations
					var testAdd = dateAdd('d', 1, result);
					expect(isDate(testAdd)).toBeTrue();
				}
			);

			it(
				title="dateArrayMin: Should handle array with single date",
				body=function() {
					var dates = [createDate(2026, 4, 15)];
					var result = utility.dateArrayMin(dates);
					expect(isDate(result)).toBeTrue();
					expect(dateFormat(result, 'yyyy-mm-dd')).toBe('2026-04-15');
				}
			);

			it(
				title="dateArrayMin: Should work with dates that have time components",
				body=function() {
					var dates = [
						createDateTime(2026, 4, 15, 10, 30, 0),
						createDateTime(2026, 4, 15, 8, 0, 0),
						createDateTime(2026, 4, 15, 14, 45, 0)
					];
					var result = utility.dateArrayMin(dates);
					expect(isDate(result)).toBeTrue();
					// Should be the 8:00 AM entry
					expect(hour(result)).toBe(8);
					expect(minute(result)).toBe(0);
				}
			);

			it(
				title="dateArrayMin: Should handle dates across different months",
				body=function() {
					var dates = [
						createDate(2026, 5, 1),
						createDate(2026, 3, 15),
						createDate(2026, 4, 20)
					];
					var result = utility.dateArrayMin(dates);
					expect(isDate(result)).toBeTrue();
					expect(dateFormat(result, 'yyyy-mm-dd')).toBe('2026-03-15');
				}
			);

			it(
				title="dateArrayMin: Should handle dates across different years",
				body=function() {
					var dates = [
						createDate(2027, 4, 15),
						createDate(2025, 12, 31),
						createDate(2026, 6, 1)
					];
					var result = utility.dateArrayMin(dates);
					expect(isDate(result)).toBeTrue();
					expect(dateFormat(result, 'yyyy-mm-dd')).toBe('2025-12-31');
				}
			);

			it(
				title="dateArrayMin: Should throw error on empty array",
				body=function() {
					var dates = [];
					var errorThrown = false;
					try {
						utility.dateArrayMin(dates);
					} catch (any e) {
						errorThrown = true;
						expect(e.type).toBe('EmptyArrayException');
					}
					expect(errorThrown).toBeTrue();
				}
			);

		});

		describe("Testing Utilities", function() {

			var utility=application.serviceFactory.getBean('utility');

			it(
				title="Should be able to set cookie",
				body=function( data ){
					utility.setCookie(name='mura_testing',value=true);
				},
				data={utility=utility  }
			);


		});

	}

}
