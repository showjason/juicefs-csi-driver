import { useLocalStorageValue } from '@react-hookz/web'

const useThemeStore = () => {
  const { value: isDark, set: setIsDark } = useLocalStorageValue('theme-storage', {
    defaultValue: false,
  })

  const toggleTheme = () => setIsDark(!isDark)

  return { isDark, toggleTheme }
}

export default useThemeStore 