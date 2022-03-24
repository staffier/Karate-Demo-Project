package sample_tests.functional_tests.helpers;

import com.github.javafaker.Faker;

public class DataGenerator {

    public static String[] getRandomAddress() {
        Faker faker = new Faker();
        String number = faker.address().buildingNumber();
        String streetName = faker.address().streetName();
        String city = faker.address().city();
        String state = faker.address().state();
        String zipCode = faker.address().zipCode();
        return new String[] {number, streetName, city, state, zipCode};
    }

    public static String getRandomCompany() {
        Faker faker = new Faker();
        String company = faker.company().name();
        return company;
    }

    public static String getRandomQuote() {
        Faker faker = new Faker();
        String description = faker.princessBride().quote();
        return description;
    }

    public static String[] getRandomName() {
        Faker faker = new Faker();
        String firstName = faker.name().firstName();
        String lastName = faker.name().lastName();
        return new String[] {firstName, lastName};
    }

}
