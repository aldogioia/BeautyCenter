package org.aldo.beautycenter;

import org.aldo.beautycenter.data.entities.Booking;
import org.aldo.beautycenter.data.entities.Service;
import org.aldo.beautycenter.data.entities.Tool;
import org.aldo.beautycenter.service.implementations.OperatorServiceImpl;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@ExtendWith(MockitoExtension.class)
public class OperatorServiceImplTest {
    @InjectMocks
    private OperatorServiceImpl operatorService;

    @Test
    void testGetAvailableSlots_withNoConflicts_returnsCorrectSlots() {
        // Arrange
        LocalTime start = LocalTime.of(9, 0);
        LocalTime end = LocalTime.of(10, 0);

        Service service = new Service();
        service.setDuration(15L);

        Tool tool = new Tool();
        tool.setAvailability(1);
        service.setTools(List.of(tool));

        // Nessuna prenotazione conflittuale
        List<Booking> operatorBookings = new ArrayList<>();
        List<Booking> roomBookings = new ArrayList<>();
        List<Booking> allBookings = new ArrayList<>();

        // Act
        List<LocalTime> availableSlots = operatorService.getAvailableSlots(
                start,
                end,
                service,
                operatorBookings,
                roomBookings,
                allBookings
        );

        availableSlots.forEach(System.out::println);

        // Assert: dalle 9:00 alle 9:45 -> 4 slot da 15 minuti, con risoluzione di 5 minuti
        assertTrue(availableSlots.contains(LocalTime.of(9, 0)));
        assertTrue(availableSlots.contains(LocalTime.of(9, 5)));
        assertTrue(availableSlots.contains(LocalTime.of(9, 10)));
        assertTrue(availableSlots.contains(LocalTime.of(9, 15)));
        assertFalse(availableSlots.contains(LocalTime.of(9, 50))); // troppo vicino al limite
        assertEquals(10, availableSlots.size()); // tra 9:00 e 9:45 -> 10 step da 5min in 1h slot
    }

    @Test
    void testGetAvailableSlots_withOperatorConflict_returnsEmptyList() {
        // Arrange
        LocalTime start = LocalTime.of(9, 0);
        LocalTime end = LocalTime.of(10, 15);

        Service service = new Service();
        service.setDuration(30L);
        service.setTools(List.of());

        Booking conflictingBooking = new Booking();
        conflictingBooking.setTime(LocalTime.of(9, 15));
        Service bookedService = new Service();
        bookedService.setDuration(30L);
        conflictingBooking.setService(bookedService);

        List<Booking> operatorBookings = List.of(conflictingBooking);

        // Act
        List<LocalTime> availableSlots = operatorService.getAvailableSlots(
                start,
                end,
                service,
                operatorBookings,
                Collections.emptyList(),
                Collections.emptyList()
        );

        availableSlots.forEach(System.out::println);

        // Assert
        assertFalse(availableSlots.contains(LocalTime.of(9, 15)));
        assertFalse(availableSlots.contains(LocalTime.of(9, 0)));
        assertTrue(availableSlots.contains(LocalTime.of(9, 45)));
    }

    @Test
    void testGetAvailableSlots_serviceTooLong_returnsEmptyList() {
        LocalTime start = LocalTime.of(9, 0);
        LocalTime end = LocalTime.of(9, 20); // solo 20 minuti disponibili

        Service service = new Service();
        service.setDuration(30L); // servizio troppo lungo

        List<LocalTime> availableSlots = operatorService.getAvailableSlots(
                start,
                end,
                service,
                Collections.emptyList(),
                Collections.emptyList(),
                Collections.emptyList()
        );

        assertTrue(availableSlots.isEmpty());
    }

    @Test
    void testGetAvailableSlots_toolUnavailable_returnsEmptyList() {
        LocalTime start = LocalTime.of(9, 0);
        LocalTime end = LocalTime.of(10, 0);

        Tool sharedTool = new Tool();
        sharedTool.setName("sharedTool");
        sharedTool.setId("1");
        sharedTool.setAvailability(1);

        Service service = new Service();
        service.setDuration(30L);
        service.setTools(List.of(sharedTool));

        Booking booking = new Booking();
        booking.setTime(LocalTime.of(9, 0));

        Service usedService = new Service();
        usedService.setDuration(35L);
        usedService.setTools(List.of(sharedTool)); // usa lo stesso oggetto

        booking.setService(usedService);

        List<Booking> allBookings = List.of(booking);

        List<LocalTime> slots = operatorService.getAvailableSlots(
                start,
                end,
                service,
                Collections.emptyList(),
                Collections.emptyList(),
                allBookings
        );

        assertTrue(slots.isEmpty(), "Should return empty list because tool is already fully booked");
    }


    @Test
    void testGetAvailableSlots_roomConflict_excludesConflictingSlot() {
        LocalTime start = LocalTime.of(9, 0);
        LocalTime end = LocalTime.of(10, 0);

        Service service = new Service();
        service.setDuration(30L);
        service.setTools(List.of());

        Booking booking = new Booking();
        booking.setTime(LocalTime.of(9, 0));
        Service roomService = new Service();
        roomService.setDuration(30L);
        booking.setService(roomService);

        List<Booking> roomBookings = List.of(booking);

        List<LocalTime> slots = operatorService.getAvailableSlots(
                start,
                end,
                service,
                Collections.emptyList(),
                roomBookings,
                Collections.emptyList()
        );

        assertFalse(slots.contains(LocalTime.of(9, 0))); // conflitto con room
    }

    @Test
    void testGetAvailableSlots_includesExactEndBoundary() {
        LocalTime start = LocalTime.of(9, 0);
        LocalTime end = LocalTime.of(9, 30);

        Service service = new Service();
        service.setDuration(30L);
        service.setTools(List.of());

        List<LocalTime> slots = operatorService.getAvailableSlots(
                start,
                end,
                service,
                Collections.emptyList(),
                Collections.emptyList(),
                Collections.emptyList()
        );

        assertTrue(slots.contains(LocalTime.of(9, 0))); // esattamente fitting
        assertFalse(slots.contains(LocalTime.of(9, 1))); // non fitting
    }

    @Test
    void testGetAvailableSlots_finalSlotExcludedIfNotFit() {
        LocalTime start = LocalTime.of(9, 0);
        LocalTime end = LocalTime.of(9, 59); // 1 minuto mancante per completare

        Service service = new Service();
        service.setDuration(60L);

        List<LocalTime> slots = operatorService.getAvailableSlots(
                start,
                end,
                service,
                Collections.emptyList(),
                Collections.emptyList(),
                Collections.emptyList()
        );

        assertTrue(slots.isEmpty()); // nessuno slot ha tempo sufficiente
    }

}
