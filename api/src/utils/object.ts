export function pick<T, K extends keyof T> (obj: T, keys: K[]): Pick<T, K> {
  return keys.reduce((res, key) => {
    res[key] = obj[key]
    return res
  }, {} as Pick<T, K>)
}
