import React, { useState, useEffect } from 'react';
import { Box, Button, Text } from "@chakra-ui/react";
import { motion } from 'framer-motion';
import Cookies from 'js-cookie';

const Game = () => {
  const [lightbulbs, setLightbulbs] = useState(0);
  const [gliders, setGliders] = useState(0);
  const [hackerspaces, setHackerspaces] = useState(0);
  const [location, setLocation] = useState('basement');
  const [animateLightbulb, setAnimateLightbulb] = useState(false);

  useEffect(() => {
    const savedLightbulbs = Cookies.get('lightbulbs');
    const savedGliders = Cookies.get('gliders');
    const savedHackerspaces = Cookies.get('hackerspaces');
    const savedLocation = Cookies.get('location');

    if (savedLightbulbs) setLightbulbs(parseInt(savedLightbulbs, 10));
    if (savedGliders) setGliders(parseInt(savedGliders, 10));
    if (savedHackerspaces) setHackerspaces(parseInt(savedHackerspaces, 10));
    if (savedLocation) setLocation(savedLocation);
  }, []);

  useEffect(() => {
    Cookies.set('lightbulbs', lightbulbs);
    Cookies.set('gliders', gliders);
    Cookies.set('hackerspaces', hackerspaces);
    Cookies.set('location', location);
  }, [lightbulbs, gliders, hackerspaces, location]);

  const generateLightbulb = () => {
    setLightbulbs(lightbulbs + 1);
    setAnimateLightbulb(true);
    setTimeout(() => setAnimateLightbulb(false), 500);
  };

  const convertToGlider = () => {
    if (lightbulbs >= 10) {
      setLightbulbs(lightbulbs - 10);
      setGliders(gliders + 1);
    }
  };

  const createHackerspace = () => {
    if (gliders >= 5) {
      setGliders(gliders - 5);
      setHackerspaces(hackerspaces + 1);
    }
  };

  const upgradeLocation = () => {
    if (hackerspaces >= 1) {
      setHackerspaces(hackerspaces - 1);
      if (location === 'basement') {
        setLocation('garage');
      } else if (location === 'garage') {
        setLocation('home lab');
      } else if (location === 'home lab') {
        setLocation('hackerspace');
      }
    }
  };

  return (
    <Box textAlign="center" p={5}>
      <Text fontSize="2xl">Hack the Planet Game</Text>
      <Text fontSize="lg">Current Location: {location}</Text>
      <Button onClick={generateLightbulb} m={2}>Generate Lightbulb</Button>
      <Button onClick={convertToGlider} m={2} isDisabled={lightbulbs < 10}>Convert to Glider</Button>
      <Button onClick={createHackerspace} m={2} isDisabled={gliders < 5}>Create Hackerspace</Button>
      <Button onClick={upgradeLocation} m={2} isDisabled={hackerspaces < 1}>Upgrade Location</Button>
      <Box mt={5}>
        <Text>Lightbulbs: {lightbulbs}</Text>
        <Text>Gliders: {gliders}</Text>
        <Text>Hackerspaces: {hackerspaces}</Text>
      </Box>
      {animateLightbulb && (
        <motion.div
          animate={{ scale: [1, 1.5, 1] }}
          transition={{ duration: 0.5 }}
          style={{ display: 'inline-block', marginTop: '20px' }}
        >
          <Text fontSize="lg" color="yellow.500">+1 Lightbulb</Text>
        </motion.div>
      )}
    </Box>
  );
};

export default Game;
