# Enviro+ Case

![Enviro Case](./images/enviro_case_right.png)

Case for an Enviro+ setup with PMS5003 particle sensor.  This case differs from other case designs because it doesn't require any screws or extra hardware to put the case together (just the standoffs for Pi HATs).  The interior of the case has supports to hold the particle sensor and the pi in place and the top is held in place by friction fit.

![Enviro Case (left)](./images/enviro_case_left.png)

![Enviro Cover](./images/enviro_cover.png)

## Sensors Parts List

The case is designed to fit these specific pieces (including the specific height of the standoffs).

- Raspberry Pi Zero WH (with headers)
- Pimoroni Enviro+
- M2.5 Standoffs, [these ones](https://shop.pimoroni.com/products/brass-m2-5-standoffs-for-pi-hats-black-plated-pack-of-2)
- PMS5003 Particulate Matter Sensor (with cable)

## Customizer Prameters

- **opening_help** - Puts a notch in the case to make it easier to open
- **separator** - Not used except to judge the height of the case to the top of the cover
- **showComponents** - Show the placeholders to adjust placement (blocks for the Raspi and the PMS5003)
- **renderItems** - Which item to render, both, cover, or box

*note that the original dimension parameters have been hidden since they need to be locked on size for the rest of the features to be in the right spot

## Printing

The case was printed using an Ender 3 v2 with all stock hardware and Hatchbox Black 1.75mm PLA.  Export the scad file into an STL and slice with your favorite slicer.

## Original Design

The case design was based off of [this box with snap on cover by Inhumierer on Thingiverse](https://www.thingiverse.com/thing:2411898).  Dimensions, supports, and cut outs were added to the design.