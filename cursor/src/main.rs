use std::collections::VecDeque;
use std::env;
use std::sync::{Arc, Mutex};
use std::thread;

use enigo::{Axis::Vertical, Button, Coordinate::Rel, Direction::Click, Enigo, Mouse};
use serial2::SerialPort;

fn main() {
    let port = SerialPort::open(
        &env::args().skip(1).next().expect("expect a port name"),
        9600,
    )
    .expect("failed to open the serial port");

    let queue_original = Arc::new(Mutex::new(VecDeque::<u8>::new()));
    let queue = queue_original.clone();
    thread::spawn(move || {
        let mut buffer = [0; 4];
        loop {
            if let Ok(read) = port.read(&mut buffer) {
                queue.lock().unwrap().extend(buffer[..read].iter());
            }
        }
    });

    let mut enigo = Enigo::new(&Default::default()).expect("failed to initialize mouse simulator");

    let queue = queue_original.clone();
    loop {
        if let Some(element) = queue.lock().unwrap().pop_front() {
            println!("{}", element);
            match element {
                0 => enigo.move_mouse(0, -10, Rel).unwrap(),      // up
                1 => enigo.move_mouse(0, 10, Rel).unwrap(),       // down
                2 => enigo.move_mouse(-10, 0, Rel).unwrap(),      // left
                3 => enigo.move_mouse(10, 0, Rel).unwrap(),       // right
                4 => enigo.button(Button::Left, Click).unwrap(),  // left click
                5 => enigo.button(Button::Right, Click).unwrap(), // right click
                6 => enigo.scroll(-1, Vertical).unwrap(),         // scroll up
                7 => enigo.scroll(1, Vertical).unwrap(),          // scroll down
                _ => (),
            }
        }
    }
}
