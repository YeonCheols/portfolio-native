import {
  DarkTheme,
  DefaultTheme,
  ThemeProvider,
} from "@react-navigation/native";
import { useFonts } from "expo-font";
import { Stack } from "expo-router";
import { StatusBar } from "expo-status-bar";
import "react-native-reanimated";

import { useColorScheme } from "@/hooks/useColorScheme";
import { WebView } from "react-native-webview";
import { Platform } from "react-native";
import { useState } from "react";

export default function RootLayout() {
  const [ready, setReady] = useState(false);
  const [webkey, setWebkey] = useState(0);

  const colorScheme = useColorScheme();
  const [loaded] = useFonts({
    SpaceMono: require("../assets/fonts/SpaceMono-Regular.ttf"),
  });

  if (!loaded) {
    return null;
  }

  return (
    <ThemeProvider value={colorScheme === "dark" ? DarkTheme : DefaultTheme}>
      {Platform.OS !== "web" && (
        <WebView
          source={{ uri: "https://www.ycseng.com " }}
          key={webkey}
          onLoadStart={(e) => {
            const { nativeEvent } = e;
            if (nativeEvent.url === "about:blank" && !ready) {
              setWebkey(Date.now());
            }
          }}
          onLoadEnd={() => {
            if (!ready) {
              setWebkey(Date.now());
              setReady(true);
            }
          }}
        />
      )}
      <Stack>
        <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
        <Stack.Screen name="+not-found" />
      </Stack>
      <StatusBar style="auto" />
    </ThemeProvider>
  );
}
