import { Button } from 'antd'
import useThemeStore from '@/hooks/use-theme'
import { ThemeIcon } from '@/icons'

const ThemeSwitch = () => {
  const { toggleTheme } = useThemeStore()
  
  return (
    <Button
      className="header-button"
      icon={<ThemeIcon />}
      onClick={toggleTheme}
    />
  )
}

export default ThemeSwitch 